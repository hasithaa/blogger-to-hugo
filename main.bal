import ballerina/io;
import ballerina/regex;
import ballerina/file;

# Path to blooger backup xml.
configurable string bloggerBackup = ?;
# Output destination
configurable string destination = "posts/";
# To Skip Draft posts.
configurable boolean skipDraft = false;
# An additional tag for imported posts.
configurable string importedTag = "";
# Additional frontmatter metadata for a post.
configurable map<int|float|decimal|string|boolean> frontmatter = {};

public function main() returns error? {
    xml<xml:Element> posts = check getBloggerPosts(bloggerBackup);
    foreach xml:Element post in posts {
        var status = generatePost(post);

        string title = (post/<title>).get(0).data();
        if status is error {
            io:println(string `Fail to generate post "${title}"`, status);
        } else if status is "skip" {
            io:println(string `Skipping draft post "${title}"`);
        } else {
            () _ = status;
        }
    }
}

xmlns "http://www.w3.org/2005/Atom";
xmlns "http://purl.org/atom/app#" as app;

function getBloggerPosts(string path) returns xml<xml:Element>|error {
    xml bloggerData = check io:fileReadXml(path);
    xml<xml:Element> x = from xml:Element entry in bloggerData/**/<entry>
        from xml:Element category in entry/<category>
        where category.scheme == "http://schemas.google.com/g/2005#kind" && category.term == "http://schemas.google.com/blogger/2008/kind#post"
        select entry;
    return x;
}

function generatePost(xml:Element post) returns error|"skip"? {

    xml draft = post/<app:control>/<app:draft>;
    boolean isDraft = draft.length() > 0 && draft.get(0).data() == "yes";
    if skipDraft && isDraft {
        return "skip";
    }

    string[] tags = from xml:Element category in post/<category>
        where category.scheme == "http://www.blogger.com/atom/ns#"
        select getFileSafeString((check category.term));
    if importedTag != "" {
        tags.push(getFileSafeString(importedTag));
    }

    string extraFrontmatter = "";
    foreach var [k, v] in frontmatter.entries() {
        extraFrontmatter = extraFrontmatter + "\n" + string `${k}: ${v.toBalString()}`;
    }

    string contnent = string `
---
title : "${regex:replaceAll((post/<title>).get(0).data(), "\"", "'")}"
date: ${(post/<published>).get(0).data()}
updated: ${(post/<updated>).get(0).data()}
tags: ${tags.toString()}${extraFrontmatter}
author: "${(post/<author>/<name>).get(0).data()}"
draft : ${isDraft}
---

${(post/<content>).get(0).data()}
`;

    check io:fileWriteString(check file:joinPath(destination, check getFileName(post)), contnent);
}

function getFileName(xml:Element post) returns string|error {
    string title = (post/<title>).get(0).data();
    string[] links = from xml:Element link in post/<link>
        where link.rel == "alternate"
        select check link.href;
    string fileName;
    if links.length() > 0 && links[0].lastIndexOf("/") != () {
        fileName = links[0].substring((links[0].lastIndexOf("/") ?: 0) + 1); // This will not be 0
    } else {
        fileName = getFileSafeString(title.toLowerAscii()) + ".html";
    }
    return fileName;
}

function getFileSafeString(string s) returns string {
    return from string codepoint in regex:replaceAll(s, " ", "-")
        where regex:matches(codepoint, "[-a-zA-Z0-9_]")
        select codepoint;
}
