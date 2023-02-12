# Maunium Synapse
This is a fork of [Synapse] to remove dumb limits and fix bugs that the
upstream devs don't want to fix.

The only official distribution is the docker image in the [GitLab container
registry], but you can also install from source ([upstream instructions]).

The master branch and `:latest` docker tag are upgraded to each upstream
release candidate very soon after release (usually within 10 minutes†). There
are also docker tags for each release, e.g. `:1.75.0`. If you don't want RCs,
use the specific release tags.

†If there are merge conflicts, the update may be delayed for up to a few days
after the full release.

[Synapse]: https://github.com/matrix-org/synapse
[GitLab container registry]: https://mau.dev/maunium/synapse/container_registry
[upstream instructions]: https://github.com/matrix-org/synapse/blob/develop/INSTALL.md#installing-from-source

## List of changes
* Default power level for room creator is 9001 instead of 100.
* Room creator can specify a custom room ID with the `room_id` param in the
  request body. If the room ID is already in use, it will return `M_CONFLICT`.
* ~~URL previewer user agent includes `Bot` so Twitter previews work properly.~~
  Upstreamed after over 2 years 🎉
* ~~Local event creation concurrency is disabled to avoid unnecessary state
  resolution.~~ Upstreamed after over 3 years 🎉
* Register admin API can register invalid user IDs.
* Docker image with jemalloc enabled by default.
* Config option to allow specific users to send events without unnecessary
  validation.
* Config option to allow specific users to receive events that are usually
  filtered away (e.g. `org.matrix.dummy_event` and `m.room.aliases`).
* Config option to allow specific users to use timestamp massaging without
  being appservice users.
* Removed bad pusher URL validation.
* webp images are thumbnailed to webp instead of jpeg to avoid losing
  transparency.
* Media repo `Cache-Control` header says `immutable` and 1 year for all media
  that exists, as media IDs in Matrix are immutable.
* Allowed sending custom data with read receipts.

You can view the full list of changes on the [meow-patchset] branch.
Additionally, historical patch sets are saved as `meow-patchset-vX` [tags].

[meow-patchset]: https://mau.dev/maunium/synapse/-/compare/patchset-base...meow-patchset
[tags]: https://mau.dev/maunium/synapse/-/tags?search=meow-patchset&sort=updated_desc

## Configuration reference
```yaml
meow:
   # List of users who aren't subject to unnecessary validation in the C-S API.
   validation_override:
   - "@you:example.com"
   # List of users who will get org.matrix.dummy_event and m.room.aliases events down /sync
   filter_override:
   - "@you:example.com"
   # Whether or not the admin API should be able to register invalid user IDs.
   admin_api_register_invalid: true
   # List of users who can use timestamp massaging without being appservices
   timestamp_override:
   - "@you:example.com"
```
