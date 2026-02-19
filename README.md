# Self Profile — Rails + React

A personal profile website built with a Ruby on Rails backend and a React frontend. Use this project to showcase your bio, projects, blog posts, and contact details with an easy-to-edit admin interface.

## Features
- Personal profile: biography, skills, experience
- Portfolio: projects with descriptions, images, and links
- Blog: create and list posts (Markdown support optional)
- Contact form: messages sent through the Rails backend
- Admin UI (optional): authenticate to edit content

## Tech Stack
- Backend: Ruby on Rails (API mode or full-stack)
- Frontend: React (Create React App, Vite, or similar)
- Database: PostgreSQL (recommended)
- Package managers: Bundler for Ruby, Yarn or npm for JavaScript

## Prerequisites
- Ruby 3.x (match `Gemfile`)
- Rails 7.x (or project-specific version)
- Node 16+ and Yarn or npm
- PostgreSQL
- Git

## Quick Setup
Clone the repo and install dependencies:

```bash
git clone <repo-url>
cd <repo-folder>

# Install Ruby gems
bundle install

# If frontend lives in `client/` or `frontend/`:
cd client
yarn install    # or `npm install`
cd ..
```

Create environment file and set secrets:

```bash
cp .env.example .env
# Edit .env to add DATABASE_URL, SECRET_KEY_BASE, etc.
```

Database setup:

```bash
rails db:create
rails db:migrate
rails db:seed   # optional
```

## Environment Variables (examples)
- `DATABASE_URL` — Postgres connection string
- `SECRET_KEY_BASE` — Rails secret
- `RAILS_ENV` — `development` / `production`
- `SMTP_URL` / mailer config — for contact form delivery
- `FRONTEND_URL` — allowed origin for CORS

## Development
Run the Rails server:

```bash
bin/rails server
# or
rails s
```

Run the React dev server (if separate):

```bash
cd client
yarn start    # or `npm start`
```

Tip: use `foreman`, `overmind`, or `concurrently` to run both servers together.

## Build & Deploy
Build the frontend for production and serve from a static host or from Rails `public/`:

```bash
cd client
yarn build    # or `npm run build`
```

Deploy Rails to Heroku, Render, or Railway. Deploy the frontend to Vercel/Netlify or serve via Rails depending on your architecture.

## Testing
- Rails tests: `bundle exec rails test` or `bundle exec rspec`
- Frontend tests: `cd client && yarn test` or `npm test`

## Project Structure (example)
- `app/` — Rails sources
- `client/` — React app (if separate)
- `config/` — Rails configuration
- `db/` — migrations and seeds

## Contributing
- Create feature branches from `main`.
- Open pull requests with a short description and testing notes.
- Follow Ruby and JS style guides (use RuboCop and ESLint if configured).

## License
Add a `LICENSE` file (MIT recommended) or choose your preferred license.

## Contact
Add your name, email, and social links here so visitors can reach you.

---

If you want, I can customize this README with exact Ruby/Rails versions, deployment steps for a specific host, or scripts to run both servers together.