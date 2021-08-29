# Blogger to Hugo post generator

blogger-to-hugo is a simple utility tool written in Ballerina to generate [Hugo](https://gohugo.io/) compatible posts from [Blogger](https://www.blogger.com/) backup data.

## How to run

This program is written using Ballerina, Hence you will need the latest version of the Ballerina disribution installed in your environment. 

1. Export Blogger backup.
   More info at https://support.google.com/blogger/answer/41387?hl=en 
2. Change Config.toml values
3. In Terminal Change directory to this project and run using `bal` command. 
   
   `bal run`

### Configuration

All the configurations are located in `Config.toml`

```toml
# Path to blooger backup xml.
bloggerBackup = "data/blog-08-25-2021.xml"

# (Optional) Output destination, Default is "posts/"
destination = "posts/blogger"

# (Optional) Skip Draft posts. Default is false
skipDraft = true

# (Optional) An additional tag for imported posts.
importedTag = "Repost"

# (Optional) Additional frontmatter metadata for a post.
frontmatter = { postSource = "blogger", showToc = false }
```

## Known Limitations

I created this for my personal use. It worked perfectly for me, and I am pretty sure it will work for you as well. Yet, it may not tests all the cases and have some limitations. 

Please free to open an issue or send a pull request with the fix. Since this is written in Ballerina, it won't take much time to add new features or fix a bug. :)
