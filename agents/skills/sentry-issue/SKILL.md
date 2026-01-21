---
name: sentry-issue
description: Fetch detailed information about a Sentry issue including error details, backtrace, and request/job context. Use when given a Sentry issue URL to investigate errors.
---

# Sentry Issue Investigation

This skill fetches comprehensive information about a Sentry issue using the Sentry MCP server.

## When to Use

Use this skill when:
- The user provides a Sentry issue URL (e.g., `https://buildrtech.sentry.io/issues/6894266400/...`)
- You need to investigate an error or exception
- You need to understand the context of a production error

## Prerequisites

The Sentry MCP server must be configured. Add to your MCP configuration:

```json
{
  "mcpServers": {
    "sentry": {
      "command": "npx",
      "args": ["-y", "mcp-remote@latest", "https://mcp.sentry.dev/mcp"]
    }
  }
}
```

## How to Fetch Sentry Issue Data

### Primary Tool: `get_sentry_issue`

Use the `mcp__sentry__get_sentry_issue` tool to fetch issue details:

**Parameters:**
- `issue_id_or_url` (string, required): The full Sentry issue URL or numeric issue ID
- `view` (string, optional): `"summary"` or `"detailed"` (default: `"detailed"`)
- `format` (string, optional): `"plain"` or `"markdown"` (default: `"markdown"`)

**Example:**
```
Tool: mcp__sentry__get_sentry_issue
Parameters:
  issue_id_or_url: "https://buildrtech.sentry.io/issues/6894266400/?environment=production"
  view: "detailed"
  format: "markdown"
```

The tool will return:
- Issue title and ID
- Status and severity level
- First seen / last seen timestamps
- Event count
- Full stacktrace
- Request/job context
- User information
- Tags and extra data

### Additional Useful Tools

#### `list_issue_events`
List all events for a specific issue:
```
Tool: mcp__sentry__list_issue_events
Parameters:
  organization_slug: "buildrtech"
  issue_id: "6894266400"
  view: "detailed"
```

#### `get_sentry_event`
Get a specific event from an issue:
```
Tool: mcp__sentry__get_sentry_event
Parameters:
  issue_id_or_url: "https://buildrtech.sentry.io/issues/6894266400/"
  event_id: "abc123def456"
  view: "detailed"
```

#### `resolve_short_id`
Look up an issue by its short ID (e.g., `PROJECT-123`):
```
Tool: mcp__sentry__resolve_short_id
Parameters:
  organization_slug: "buildrtech"
  short_id: "BUILDR-12345"
```

## Parsing Sentry URLs

Sentry URLs contain useful information:

```
https://{org}.sentry.io/issues/{issue_id}/?environment={env}&project={project_id}
```

Components:
- **Organization slug**: The subdomain (e.g., `buildrtech`)
- **Issue ID**: The numeric ID in the path (e.g., `6894266400`)
- **Project ID**: From the `project` query parameter
- **Environment**: From the `environment` query parameter

You can pass the entire URL directly to `get_sentry_issue` - no parsing required.

## Information to Extract and Present

When presenting Sentry issue information, include:

### Error Summary
- **Title**: The error message/type
- **Culprit**: The file/method where the error occurred
- **Level**: Error severity (error, warning, info)
- **First Seen**: When the error first occurred
- **Last Seen**: Most recent occurrence
- **Count**: Total number of occurrences

### Stack Trace
Present the stack trace with:
- File path and line number
- Function/method name
- Code context (surrounding lines)
- Highlight application code vs library code

Example formatting:
```
app/services/foo_service.rb:42 in `process_data`
  40 |     data.each do |item|
  41 |       result = transform(item)
> 42 |       save_result(result)  # <-- Error occurred here
  43 |     end
  44 |   end
```

### Request Context (for web errors)
- Request URL and HTTP method
- Request headers (relevant ones)
- Request parameters/body
- Session information

### Job Context (for background jobs)
- Job class name
- Queue name
- Job arguments
- Job ID

### User Context
- User ID
- Email
- Username or other identifiers

### Tags and Additional Context
- Environment (production, staging, etc.)
- Release version
- Browser/OS information
- Custom tags

## Example Output Format

```markdown
## Sentry Issue: NoMethodError - undefined method `name` for nil:NilClass

**Issue ID**: 6894266400
**Environment**: production
**Level**: error
**First Seen**: 2025-01-15 14:32:00 UTC
**Last Seen**: 2025-01-16 09:15:00 UTC
**Occurrences**: 47

### Error
**Type**: NoMethodError
**Message**: undefined method `name` for nil:NilClass
**Culprit**: app/services/user_service.rb in get_display_name

### Stack Trace (most recent call last)

app/services/user_service.rb:28 in `get_display_name`
  26 |   def get_display_name(user_id)
  27 |     user = User.find_by(id: user_id)
> 28 |     user.name  # user is nil here
  29 |   end

app/controllers/users_controller.rb:15 in `show`
  13 |   def show
  14 |     @user_id = params[:id]
> 15 |     @display_name = UserService.get_display_name(@user_id)
  16 |   end

### Request Context
- **URL**: GET /users/12345
- **IP**: 192.168.1.100
- **User Agent**: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)

### User Context
- **User ID**: 98765
- **Email**: user@example.com

### Tags
- release: v2.3.1
- server_name: web-prod-01
- transaction: UsersController#show
```

## Troubleshooting

### MCP Server Not Available
If the Sentry MCP tools are not available, fall back to the API approach:

```bash
# Requires SENTRY_AUTH_TOKEN environment variable
curl -s -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/" | jq '.'

curl -s -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/issues/{issue_id}/events/latest/" | jq '.'
```

### Common Errors
- **401 Unauthorized**: Token is invalid or missing required scopes
- **404 Not Found**: Issue ID doesn't exist or user lacks access
- **429 Rate Limited**: Too many requests, wait and retry
