# Cline Rules — WhoHasMy Project

## Mandatory: Load Project Instructions Before Every Task

**Before implementing ANY story, feature, bugfix, or code change, you MUST:**

1. **Read and follow all procedures in the root `instruction.md` file.**
   - Path: `/Users/jcreid/Documents/SW_DEV/Projects/WhoHasMy/instruction.md`
   - This file contains the complete development workflow including branch creation, Jira transitions, test execution, PR creation, and commit conventions.

2. **Execute every step in `instruction.md`'s Quick Reference Checklist** (steps 1–14) before writing any code:
   - Create a feature branch using the naming convention `<owner>-<phase>-STORY###`
   - Push the branch to remote origin
   - Transition the Jira issue through proper workflow states (not raw status changes)
   - Assign the story appropriately
   - Review design documentation on Confluence/Figma if impacted
   - Run `flutter test` and post full results as a comment on the Jira story
   - Only transition to "In Review" after all tests pass and results are posted
   - Commit with message format: `<jira-id>-<status>` (e.g., `WHOH-3-dev-complete`)
   - Push changes and create a Pull Request linked to the Jira issue

3. **Do NOT skip any step.** The workflow in `instruction.md` is mandatory, not optional.

## Why This File Exists

Cline does not automatically load project-specific instruction files from the repository root. This file serves as an explicit directive: **always read and follow `/Users/jcreid/Documents/SW_DEV/Projects/WhoHasMy/instruction.md` before starting any implementation work.**

## Reference

- Full workflow details, naming conventions, architecture rules, and code generation procedures are in `instruction.md`.
- This file is a gate — it ensures the agent never starts coding without first loading the project's complete development standards.
