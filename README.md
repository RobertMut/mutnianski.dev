# mutnianski.dev

Jekyll site using the [Hydejack](https://github.com/hydecorp/hydejack) theme, published at [mutnianski.dev](https://mutnianski.dev) with GitHub Pages.

## Local development

Install Ruby and Bundler, then run:

```sh
bundle install
bundle exec jekyll serve --livereload
```

Open `http://localhost:4000`.

On Windows, use the [Jekyll Windows installation guide](https://jekyllrb.com/docs/installation/windows/) to install Ruby with Devkit first.

If Ruby is not installed but Docker is available, run:

```powershell
docker run --rm -p 4000:4000 -e BUNDLE_PATH=vendor/bundle -v "${PWD}:/srv/jekyll" -w /srv/jekyll ruby:3.2.2 bash -lc "bundle install && bundle exec jekyll serve --host 0.0.0.0"
```

## Content

- Add blog posts to `_posts/` using `YYYY-MM-DD-title.md` filenames.
- Add portfolio entries to `_projects/`.
- Omit `external_url` for a local project page, or set it to send visitors directly to an external site.
- Replace the Lorem Ipsum copy in `index.html`, `about.md`, `_posts/`, and `_projects/`.

## Deployment

The workflow in `.github/workflows/pages.yml` installs the bundled Hydejack/Jekyll dependencies, builds the site, and deploys pushes to `main`.

In the repository settings, open **Pages** and set **Source** to **GitHub Actions**. Then configure `mutnianski.dev` as the custom domain and enable HTTPS after DNS validation succeeds.
