# AGENTS.md

## Project Context

- **Name**: distance.tools-skills
- **Repo**: /Users/stephan/Sites/Distance.Tools/distance.tools-skills
- **Description**: Creating SKILLS for distance.tools-suite. Begin with supporting simple skill that reads input and returns distance by calling the distance API.
- **Status**: ✅ Production Ready

## Current State

- Status: Fully functional and tested
- Discovered: 2026-04-10
- Update: 2026-04-10 (installer and documentation complete)

## Tools

- OpenSpec: Specification framework
- OpenCode: Implementation support
- GitHub: Distribution platform
- bash/curl/jq: Execution environment

## Current Implementation

**Skills Implemented**: 1 (distance-route)
**Installation**: One-line installer ready
**Documentation**: Complete
**Testing**: All transport modes validated

## Installation & Usage

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/StephanGeorg/distance.tools-skills/main/install | bash

# Usage example
distance-route.sh "Paris" "Berlin" "car"
```

## Architecture

- Root installer: install (executable)
- README: Installation guide
- Skills: distance-route with full functionality
- Documentation: API guide, getting started, examples

---
Project is production-ready and deployable. 🚀
