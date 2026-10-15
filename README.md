# Somulator: modified AGPL files

Somulator is a social-media simulation platform for training, exercises and research, developed by the Norwegian
Defence Research Establishment (FFI). It runs open-source platforms as "clones" of well-known services:
Mastodon (X/Twitter), Friendica (Facebook), Pixelfed (Instagram), PeerTube (YouTube) and Ghost (online newspapers).

Mastodon, Friendica, Pixelfed and PeerTube are licensed under the GNU Affero General Public License v3 (AGPLv3).
For practical purposes Somulator changes a few of their files. This repository publishes those modified files, as
required by AGPLv3 section 13, so that anyone using a Somulator instance can obtain the source of what they use.
Ghost (MIT licence) is used unmodified.

## Layout

Each folder holds the modified files of one platform, at the same path as in that platform's own source
repository, so they can be laid over the upstream source:

| Folder | Upstream source |
|---|---|
| `mastodon/` | https://github.com/mastodon/mastodon |
| `friendica/` | https://github.com/friendica/friendica |
| `pixelfed/` | https://github.com/pixelfed/pixelfed |
| `peertube/` | https://github.com/Chocobozzz/PeerTube |

`VERSIONS.md` lists, for the current Somulator release, the exact upstream version (tag) each platform is built
from, and the files changed. Everything else is the unmodified upstream source at that tag.

## Releases

Each Somulator release that is deployed publishes its files here: the git tag `v<n>` matches Somulator release `<n>`
(for example `v3.31`). The `main` branch always holds the files of the latest release.

## Licence

The files in the platform folders are modified versions of AGPLv3-licensed files and are licensed under the AGPLv3,
as their originals: https://www.gnu.org/licenses/agpl-3.0.html

## Contact

Norwegian Defence Research Establishment (FFI), Instituttveien 20, 2007 Kjeller, Norway.
