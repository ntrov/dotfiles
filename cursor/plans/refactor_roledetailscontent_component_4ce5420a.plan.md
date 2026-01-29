---
name: Refactor RoleDetailsContent Component
overview: Break down the 699-line RoleDetailsContent component into smaller, maintainable pieces by extracting custom hooks, sub-components, utility functions, and types into separate files.
todos:
  - id: extract-types
    content: Add GroupedPermissions, ModuleAccessControl, and other shared types to UserManagementApi.ts
    status: pending
  - id: extract-utils
    content: Create utils/permissionHelpers.ts with calculateColumns, splitSectionsIntoColumns, and groupPermissionsByTabModuleSection functions
    status: pending
  - id: extract-grouped-permissions-hook
    content: Create hooks/useGroupedPermissions.ts to extract permission grouping logic
    status: pending
  - id: extract-access-control-hook
    content: "Create hooks/useModuleAccessControl.ts to extract module access control state management and logic. CRITICAL: Preserve exact useEffect synchronization logic (lines 268-279) that syncs moduleAccessControls with determineModuleAccessControl while respecting manuallySetModules"
    status: pending
  - id: extract-selection-hook
    content: Create hooks/usePermissionSelection.ts to extract permission selection handlers
    status: pending
  - id: extract-permission-section
    content: Create components/PermissionSection.tsx component to extract renderSection logic
    status: pending
  - id: extract-permission-module
    content: Create components/PermissionModule.tsx component to extract renderModule logic
    status: pending
  - id: extract-permission-tabs
    content: Create components/PermissionTabs.tsx component for tab rendering
    status: pending
  - id: refactor-main-component
    content: "Refactor RoleDetailsContent.tsx to use all extracted hooks and components, reducing it to ~150 lines. FIX: Change useMemo to useEffect on line 163. FIX: Remove duplicate loading check"
    status: pending
---

# Refactor RoleDetailsContent Component

## Current Issues

- **699 lines** in a single component file
- Multiple responsibilities: data transformation, state management, and UI rendering
- Complex logic mixed with presentation (permission grouping, access control determination)
- Large inline render functions (`renderSection`, `renderModule`)
- Repeated code patterns (duplicate loading checks, manual flag clearing)
- Utility functions and types defined inline
- **BUG**: `useMemo` used for side effects on line 163 (should be `useEffect`)
- **BUG**: Duplicate loading check on lines 373 and 647

## Refactoring Strategy

### 1. Extract Types (`UserManagementApi.ts`)

Add types to `src/app/(control-panel)/user-management/UserManagementApi.ts`:

- `GroupedPermissions` type
- `ModuleAccessControl` type
- `RoleDetailsContentProps` type
- Other shared types

### 2. Extract Utility Functions (`utils/permissionHelpers.ts`)

Create `src/app/(control-panel)/user-management/role-detail/utils/permissionHelpers.ts`:

- `calculateColumns()` - Calculate optimal grid columns based on permission title lengths
- `splitSectionsIntoColumns()` - Split sections into left/right columns for display
- `groupPermissionsByTabModuleSection()` - Extract the complex grouping logic from `groupedPermissions` memo

### 3. Extract Custom Hooks

#### `hooks/useGroupedPermissions.ts`

- Extract the `groupedPermissions` memo logic (lines 78-152)
- Handle permission grouping by tab -> module -> section
- Return grouped and sorted permissions

#### `hooks/useModuleAccessControl.ts`

- Extract module access control state management
- Handle `moduleAccessControls` state
- Handle `manuallySetModules` state
- Extract `determineModuleAccessControl` logic (lines 170-265)
- Extract `handleModuleAccessControlChange` logic (lines 291-353)
- **CRITICAL**: Preserve exact `useEffect` synchronization logic (lines 268-279) that syncs `moduleAccessControls` with `determineModuleAccessControl` while respecting `manuallySetModules`
- **CRITICAL**: Must receive `groupedPermissions`, `permissionIds`, `permissionsData`, `tabValue`, and `setValue` as dependencies
- Return access control state and handlers

#### `hooks/usePermissionSelection.ts`

- Extract permission selection logic
- Handle `handlePermissionToggle`
- Handle clearing manual flags when permissions are manually changed
- Return selection handlers

### 4. Extract Sub-Components

#### `components/PermissionSection.tsx`

- Extract `renderSection` function (lines 398-522)
- Props: `sectionGroup`, `moduleName`, `isViewMode`, `showDivider`, `onClearManualFlag`
- Handle section header with "Select All" checkbox
- **CRITICAL**: Must call `onClearManualFlag(moduleName)` when "Select All" or individual checkboxes are toggled (lines 449-453, 499-503)
- Render permissions grid with dynamic columns
- Uses `useFormContext` for form access (component stays within FormProvider)

#### `components/PermissionModule.tsx`

- Extract `renderModule` function (lines 524-644)
- Props: `moduleGroup`, `moduleAccessControl`, `onAccessControlChange`, `isViewMode`, `onClearManualFlag`
- Handle module header with access control radio buttons
- Handle single vs. multi-section layout
- Render sections using `PermissionSection` (pass `onClearManualFlag` prop)

#### `components/PermissionTabs.tsx`

- Extract tab rendering logic (lines 660-675)
- Props: `tabs`, `tabValue`, `onTabChange`
- Simple wrapper around `FuseTabs`

### 5. Refactor Main Component (`RoleDetailsContent.tsx`)

Simplify to:

- Use extracted hooks in correct order:

  1. `useGroupedPermissions` (depends on `permissionsData`)
  2. `useModuleAccessControl` (depends on `useGroupedPermissions` result)
  3. `usePermissionSelection` (depends on `useModuleAccessControl` result)

- Use extracted sub-components (`PermissionTabs`, `PermissionModule`)
- Handle loading and empty states (remove duplicate check)
- **FIX**: Change `useMemo` on line 163 to `useEffect` for setting initial tab value
- **FIX**: Remove duplicate loading check (keep only one)
- Orchestrate the overall layout
- **CRITICAL**: All hooks must be called within FormProvider context (already satisfied)

## File Structure After Refactoring

```
role-detail/
├── components/
│   ├── PermissionSection.tsx (new)
│   ├── PermissionModule.tsx (new)
│   ├── PermissionTabs.tsx (new)
│   ├── RoleDetailsContent.tsx (refactored, ~150 lines)
│   ├── RoleDetailsContentSkeleton.tsx
│   ├── RoleDetailsHeader.tsx
│   ├── PermissionDependenciesDialog.tsx
│   └── SaveRoleConfirmationDialog.tsx
├── hooks/
│   ├── useGroupedPermissions.ts (new)
│   ├── useModuleAccessControl.ts (new)
│   ├── usePermissionSelection.ts (new)
│   └── useRoleAddEditForm.tsx
├── utils/
│   ├── permissionHelpers.ts (new)
│   ├── moduleTabMapping.ts
│   ├── sectionAccessMapping.ts
│   └── validation.ts
└── (types added to UserManagementApi.ts)
```

## Benefits

- **Maintainability**: Each file has a single, clear responsibility
- **Readability**: Smaller files are easier to understand
- **Testability**: Hooks and utilities can be tested independently
- **Reusability**: Sub-components and hooks can be reused elsewhere
- **Performance**: Easier to optimize individual pieces

## Risk Assessment

**Overall Risk Level**: 🟡 Medium

**Key Risks**:

1. **State Synchronization**: The `useEffect` that syncs `moduleAccessControls` with `determineModuleAccessControl` must be preserved exactly. If broken, radio buttons won't update correctly when permissions change.
2. **Manual Flag Logic**: The `manuallySetModules` Set prevents auto-updates from overriding user selections. Must be cleared in all 3 places where users manually change permissions.
3. **Form Context**: All hooks must be called within FormProvider context (already satisfied by component structure).

**Mitigations**:

1. Preserve exact logic for state synchronization in `useModuleAccessControl` hook
2. Ensure manual flag clearing is called in all permission change handlers
3. Test all interaction scenarios thoroughly after refactoring
4. Fix identified bugs (`useMemo` → `useEffect`, duplicate loading check)

## Critical Implementation Notes

### State Synchronization (MUST PRESERVE)

The `useEffect` on lines 268-279 is critical for syncing `moduleAccessControls` with computed `determineModuleAccessControl` while respecting `manuallySetModules`. This logic must be preserved exactly in `useModuleAccessControl` hook.

### Manual Flag Clearing (MUST PRESERVE)

The `manuallySetModules` Set prevents auto-updates from overriding user selections. It must be cleared when:

1. User toggles "Select All" checkbox (lines 449-453)
2. User toggles individual permission checkbox (lines 499-503)
3. User changes module access control radio (adds to Set, line 293-297)

### Form Context Access

All hooks and components will maintain access to `useFormContext` because they're called/rendered within the FormProvider in `RoleDetail.tsx`.

### Hook Dependencies

- `useGroupedPermissions`: needs `permissionsData`
- `useModuleAccessControl`: needs `groupedPermissions`, `permissionIds`, `permissionsData`, `tabValue`, `setValue`
- `usePermissionSelection`: needs `onClearManualFlag` callback from `useModuleAccessControl`

## Implementation Order

1. Add types to `UserManagementApi.ts` (GroupedPermissions, ModuleAccessControl, etc.)
2. Create `utils/permissionHelpers.ts` with utility functions
3. Create `hooks/useGroupedPermissions.ts`
4. Create `hooks/useModuleAccessControl.ts` (most complex - preserve exact synchronization logic)
5. Create `hooks/usePermissionSelection.ts`
6. Create `components/PermissionSection.tsx` (preserve manual flag clearing)
7. Create `components/PermissionModule.tsx`
8. Create `components/PermissionTabs.tsx`
9. Refactor `components/RoleDetailsContent.tsx`:

   - Fix `useMemo` → `useEffect` bug (line 163)
   - Remove duplicate loading check
   - Use all extracted hooks and components

## Testing Checklist

After refactoring, verify:

1. ✅ Loading state shows skeleton
2. ✅ Empty state shows "No permissions available"
3. ✅ Tabs render and switch correctly
4. ✅ Initial tab is set correctly when tabs load
5. ✅ Modules render with correct access control radio buttons
6. ✅ Radio button changes update permissions correctly
7. ✅ Manual permission checkbox changes clear manual flag
8. ✅ "Select All" checkbox works for sections and clears manual flag
9. ✅ Permission changes don't override manual radio selections
10. ✅ Module access controls sync with permission selections (auto-update when not manually set)
11. ✅ Form submission includes correct permission IDs
12. ✅ View mode disables all interactions
13. ✅ No console errors or warnings
