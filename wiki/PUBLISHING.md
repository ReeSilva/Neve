# Publishing Wiki Pages to GitHub

This guide explains how to publish the wiki content from the `wiki/` directory to your GitHub repository's wiki.

## Method 1: Manual Copy (Easiest)

### Step 1: Enable Wiki

1. Go to https://github.com/reesilva/neve
2. Click **Settings** tab
3. Scroll down to **Features** section
4. Check the **Wikis** checkbox if not already enabled

### Step 2: Create Pages

For each `.md` file in the `wiki/` directory:

1. Go to https://github.com/reesilva/neve/wiki
2. Click **New Page**
3. Copy the filename (without `.md`) as the page title
   - `Home.md` → title: "Home"
   - `Terragrunt-LS.md` → title: "Terragrunt LS"
   - `Custom-Built-Plugins.md` → title: "Custom Built Plugins"
4. Paste the file contents into the editor
5. Click **Save Page**

### Files to Create

- `Home.md` → "Home" (main page)
- `Terragrunt-LS.md` → "Terragrunt LS"
- `Custom-Built-Plugins.md` → "Custom Built Plugins"

## Method 2: Git Clone (Recommended for Multiple Updates)

GitHub wikis are actually Git repositories! You can clone and push to them.

### Step 1: Clone the Wiki Repository

```bash
# Clone your wiki (it's a separate repo)
git clone https://github.com/reesilva/neve.wiki.git

cd neve.wiki
```

### Step 2: Copy Wiki Files

```bash
# Copy all wiki files from the main repo
cp ../wiki/*.md .

# Check what was copied
ls -la *.md
```

### Step 3: Commit and Push

```bash
# Add all markdown files
git add *.md

# Commit
git commit -m "Add wiki documentation for custom plugins and terragrunt-ls"

# Push to GitHub
git push origin master
```

### Step 4: Verify

Visit https://github.com/reesilva/neve/wiki to see your pages live!

## Method 3: Using GitHub CLI (gh)

If you have `gh` installed:

### Step 1: Ensure Wiki is Enabled

```bash
gh repo edit reesilva/neve --enable-wiki
```

### Step 2: Clone and Update

```bash
# Clone the wiki
gh repo clone reesilva/neve.wiki

cd neve.wiki

# Copy files
cp ../wiki/*.md .

# Commit and push
git add *.md
git commit -m "Add comprehensive wiki documentation"
git push
```

## After Publishing

### Verify the Pages

1. Go to https://github.com/reesilva/neve/wiki
2. You should see:
   - **Home** - Landing page with navigation
   - **Terragrunt LS** - Complete plugin documentation
   - **Custom Built Plugins** - Overview of custom plugins

### Update Links

The pages link to each other. Verify all links work:

- Home → Terragrunt LS
- Home → Custom Built Plugins
- Custom Built Plugins → Terragrunt LS
- All external links (GitHub files, etc.)

### Add to README

Update the main README.md to link to the wiki:

```markdown
## 📚 Documentation

For detailed documentation, see the [Wiki](https://github.com/reesilva/neve/wiki):

- [Terragrunt Language Server Setup](https://github.com/reesilva/neve/wiki/Terragrunt-LS)
- [Custom Built Plugins](https://github.com/reesilva/neve/wiki/Custom-Built-Plugins)
```

## Updating Wiki Pages

### Future Updates

When you need to update wiki content:

#### Method A: Edit on GitHub

1. Go to the wiki page
2. Click **Edit**
3. Make changes
4. Click **Save Page**

#### Method B: Via Git

```bash
cd neve.wiki

# Make changes to .md files
vim Terragrunt-LS.md

# Commit and push
git add Terragrunt-LS.md
git commit -m "Update terragrunt-ls documentation"
git push
```

### Keep in Sync

Consider keeping the `wiki/` directory in your main repo synchronized:

```bash
# In the main repo
cp ../neve.wiki/*.md wiki/

git add wiki/
git commit -m "Sync wiki changes back to main repo"
git push
```

## Troubleshooting

### Wiki Not Available

**Problem**: Wiki option is grayed out

**Solution**: 
- Repository must be public or you need admin access
- Check repository settings

### Clone Fails

**Problem**: `git clone` fails for wiki

**Solution**:
- Ensure wiki is enabled
- Create at least one page via web UI first
- Then try cloning again

### Push Rejected

**Problem**: `git push` fails

**Solution**:
```bash
# Pull first
git pull origin master

# Then push
git push origin master
```

### Links Not Working

**Problem**: Internal wiki links broken

**Solution**: GitHub wiki links should use this format:
- `[Text](Page-Name)` - for wiki pages
- No `.md` extension needed
- Spaces become hyphens

Example:
```markdown
[Terragrunt LS](Terragrunt-LS)  # Correct
[Terragrunt LS](Terragrunt-LS.md)  # Wrong
```

## Wiki Structure

After publishing, your wiki will have this structure:

```
https://github.com/reesilva/neve/wiki
├── Home                        (Home.md)
├── Terragrunt-LS              (Terragrunt-LS.md)
└── Custom-Built-Plugins       (Custom-Built-Plugins.md)
```

### Navigation

GitHub automatically creates:
- Sidebar with all pages
- Search functionality
- Page history
- Clone URL

## Markdown Features

GitHub wiki supports:

- ✅ Standard Markdown
- ✅ GitHub Flavored Markdown (GFM)
- ✅ Tables
- ✅ Code blocks with syntax highlighting
- ✅ Task lists
- ✅ Emoji
- ✅ Internal links
- ✅ External links
- ✅ Images

## Best Practices

### Page Names

- Use title case: "Terragrunt LS", not "terragrunt-ls"
- Keep URLs readable: "Custom-Built-Plugins"
- Avoid special characters

### Content

- Keep pages focused on one topic
- Use clear hierarchical headings
- Include table of contents for long pages
- Link between related pages
- Update regularly

### Maintenance

- Review pages quarterly
- Update with new features
- Fix broken links
- Archive outdated content

## Quick Reference

### Clone Wiki
```bash
git clone https://github.com/reesilva/neve.wiki.git
```

### Update Wiki
```bash
cd neve.wiki
# Edit files
git add *.md
git commit -m "Update wiki"
git push origin master
```

### Link to Wiki in README
```markdown
[Wiki](https://github.com/reesilva/neve/wiki)
```

### Internal Wiki Link
```markdown
[Page Name](Page-Name)
```

## Next Steps

After publishing:

1. ✅ Verify all pages are accessible
2. ✅ Test all internal links
3. ✅ Add wiki link to README
4. ✅ Announce in repository discussions
5. ✅ Keep content updated

---

For questions or issues with wiki publishing, see the [GitHub Wiki documentation](https://docs.github.com/en/communities/documenting-your-project-with-wikis).
