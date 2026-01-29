---
name: Redirect to dashboard after organization switch
overview: Replace `window.location.reload()` with `window.location.href = '/dashboard'` to redirect to the dashboard page and clear cache after switching organizations.
todos:
  - id: update-organization-dialog-redirect
    content: Replace window.location.reload() with window.location.href = '/dashboard' in OrganizationDialog.tsx
    status: pending
---

## Plan: Redirect to Dashboard After Organization Switch

Currently, after switching organizations in `OrganizationDialog.tsx`, the code uses `window.location.reload()` which reloads the current page. The user wants to redirect to the dashboard page instead and ensure the cache is cleared.

### Implementation

**File to modify:**

- [`src/components/theme-layouts/layout1/components/OrganizationDialog.tsx`](src/components/theme-layouts/layout1/components/OrganizationDialog.tsx)

**Change:**

Replace line 67:

```typescript
window.location.reload();
```

With:

```typescript
window.location.href = '/dashboard';
```

### Rationale

1. **Consistent with codebase**: Similar organization switch flows in `AcceptInviteScreen.tsx` and `WelcomeScreen.tsx` use `window.location.href = '/dashboard'` (lines 75 and 67 respectively).

2. **Cache clearing**: Using `window.location.href` performs a full page navigation to `/dashboard`, which clears the browser cache and ensures a fresh load of the dashboard with the new organization context.

3. **User experience**: Redirecting to the dashboard provides a consistent landing point after organization switches, rather than staying on the current page.

This is a simple, one-line change that aligns with existing patterns in the codebase.