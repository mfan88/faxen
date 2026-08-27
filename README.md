# faxen

A secure upload portal for all your needs.

Faxen is how you send files when an email attachment is not enough. Transfers are encrypted in transit and at rest. Links can expire, be limited to specific people, and be revoked in one click.

Built by [fenna.tech](https://fenna.tech).

## Who it is for

There are two sides to Faxen:

- **Operators** create and control links. They should be able to do that from a console, a browser, or a native app — not from one place only.
- **Everyone else** uses a link to upload or download. They should not need an account or a special app.

This repository is the **web client**. More operator clients are planned so the same links can be managed from wherever you already work.

| Client | Status |
| --- | --- |
| Web | In progress (this repo) |
| Console (CLI) | Planned |
| macOS | Planned |
| Windows | Planned |
| Linux | Planned |
| iOS | Planned |

## Preview
View the landing page in action [here](https://faxen.fenna.tech)

## This repository

`faxen-web` is the browser client: the public landing surface and, next, the in-browser portal.

Stack: Next.js, React, Tailwind CSS, TypeScript. Package manager: [Bun](https://bun.sh).

## License

Private. All rights reserved.
