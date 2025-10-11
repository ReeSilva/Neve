# GitHub Actions Workflows

This directory contains automated workflows for maintaining the Neve Neovim configuration.

## Workflows

### `update.yml` - Nix Flake Check

Runs on pull requests to ensure code quality and flake integrity.

**Triggers:**
- Pull requests

**Actions:**
- Checks out the repository
- Installs Nix and development tools
- Updates flake inputs
- Runs `statix` for linting
- Runs `alejandra` for formatting
- Validates flake with `flake-checker`
- Auto-commits any formatting changes

### `update-plugins.yml` - Update Custom Plugins

Automatically checks for and updates custom-built plugins from their upstream sources.

**Triggers:**
- Scheduled: Daily at 00:00 UTC
- Manual: Via `workflow_dispatch`

**What it does:**

1. **Check for Updates**
   - Queries the upstream repository for the latest commit
   - Compares with the current version in the module
   - Determines if an update is needed

2. **Calculate New Hash**
   - Fetches the new version from GitHub
   - Calculates the correct Nix hash (SHA256)
   - Verifies the hash is valid

3. **Update Module**
   - Updates the `rev` field to the latest commit SHA
   - Updates the `hash` field with the calculated hash
   - Formats the code with `alejandra`

4. **Test Build**
   - Builds the flake to ensure nothing breaks
   - Verifies the new plugin version works correctly

5. **Create Pull Request**
   - Creates an automated PR with detailed information
   - Includes commit message, date, and changelog link
   - Labels: `dependencies`, `automated`, `plugins`

**Currently Monitored Plugins:**
- `terragrunt-ls` - Terragrunt Language Server from [gruntwork-io/terragrunt-ls](https://github.com/gruntwork-io/terragrunt-ls)

## Pull Request Format

When `update-plugins.yml` finds an update, it creates a PR with:

```markdown
## Automated Plugin Update

This PR updates the `terragrunt-ls` plugin to the latest version.

### Changes
- **Plugin**: terragrunt-ls
- **New Commit**: [abc1234](https://github.com/gruntwork-io/terragrunt-ls/commit/abc1234)
- **Commit Message**: Fix: some bug fix
- **Commit Date**: 2025-01-15T12:00:00Z
- **New Hash**: sha256-...

### Upstream Repository
https://github.com/gruntwork-io/terragrunt-ls

### Verification
- ✅ Flake build tested successfully
- ✅ Hash verified
- ✅ Code formatted with alejandra
```

## Adding New Plugins to Auto-Update

To add a new plugin to the auto-update workflow:

1. **Add the plugin module** following the pattern in `config/lsp/terragrunt-ls.nix`:
   ```nix
   src = pkgs.fetchFromGitHub {
     owner = "org-name";
     repo = "repo-name";
     rev = "commit-sha-or-branch";
     hash = "sha256-...";
   };
   ```

2. **Add a new job** to `.github/workflows/update-plugins.yml`:
   ```yaml
   update-your-plugin:
     runs-on: ubuntu-latest
     permissions:
       contents: write
       pull-requests: write
     steps:
       # Copy and modify the steps from update-terragrunt-ls
       # Update the repository owner/name and file paths
   ```

3. **Update the README** to document the new plugin

## Manual Workflow Trigger

You can manually trigger the update check:

1. Go to Actions tab in GitHub
2. Select "Update Custom Plugins" workflow
3. Click "Run workflow"
4. Select the branch (usually `main`)
5. Click "Run workflow" button

## Troubleshooting

### Build Failures

If the automated PR shows build failures:
1. Check the workflow logs for specific errors
2. The hash calculation might have failed
3. The upstream repository might have breaking changes

### No PRs Created

If you expect an update but no PR is created:
1. Check if the workflow ran successfully in Actions tab
2. Verify the upstream repository has new commits
3. Check the workflow logs for comparison results

### Hash Mismatch

If you see hash mismatch errors:
1. The workflow will automatically calculate the correct hash
2. If it fails, you can manually update by running:
   ```bash
   nix-build -E 'with import <nixpkgs> {}; fetchFromGitHub { 
     owner = "gruntwork-io"; 
     repo = "terragrunt-ls"; 
     rev = "COMMIT_SHA"; 
     hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
   }' 2>&1 | grep "got:"
   ```

## Permissions Required

The workflows require the following GitHub token permissions:
- `contents: write` - To commit changes and push branches
- `pull-requests: write` - To create pull requests

These are automatically provided by `${{ secrets.GITHUB_TOKEN }}`.

## Workflow Configuration

### Schedule Configuration

The update workflow runs daily at midnight UTC. To change the schedule, edit the cron expression:

```yaml
schedule:
  - cron: '0 0 * * *'  # Daily at 00:00 UTC
  # Examples:
  # - cron: '0 0 * * 0'    # Weekly on Sunday
  # - cron: '0 0 1 * *'    # Monthly on the 1st
  # - cron: '0 */12 * * *' # Every 12 hours
```

### Notification Settings

To receive notifications for automated PRs:
1. Go to repository Settings → Notifications
2. Configure "Actions" notifications
3. You'll be notified when PRs are created

## Security Considerations

- Workflows use official GitHub Actions from trusted sources
- Nix builds are reproducible and hash-verified
- All changes are reviewed via pull requests
- No secrets or credentials are exposed
- Updates only come from verified upstream sources

## Related Documentation

- [Update Plugin Guide](../../TERRAGRUNT-LS-SETUP.md#updating-the-plugin)
- [Plugin Module](../../config/lsp/terragrunt-ls.nix)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
