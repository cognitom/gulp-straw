# Gulp Straw

Gulp Task Manager: The command-line tool for managing your `gulpfile`.
`gulpfile` is a task file for [gulp.js](http://gulpjs.com).

## Features

0. install `gulpfile` from GitHub
0. update `gulpfile` from GitHub
0. publish `gulpfile` to GitHub
0. solve the dependencies on `package.json`

## Installation

Install `gulp-straw` from `npm` with:

```bash
$ npm install -g gulp-straw
```

Straw requires you to authenticate with GitHub. Add the following entry to your ~/.netrc file:

```
machine api.github.com
  login <username>
  password <token>
```

You can create a new `token` here: https://github.com/settings/tokens/new

## Getting Started

### Install gulpfiles

Get gulpfiles from your repository:

```bash
$ cd ./path/to/project/
$ straw install gulpfile
$ straw install task/css
```

Get gulpfiles from others:

```bash
$ straw install cognitom/gulpfiles:gulpfile
$ straw install cognitom/gulpfiles:task/css
```

If the repository name is ommited `straw` guess that the name would be `gulpfiles`. So these command can also be written like below.

```bash
$ straw install cognitom:gulpfile
$ straw install cognitom:task/css
```

Install all specified in `package.json`:

```bash
$ straw install
```

### Update gulpfiles

Update all specified in `package.json`:

```bash
$ straw update
```

Update gulpfiles:

```bash
$ straw update task/css
```

### Publish gulpfiles

```bash
$ straw publish task/css
```

## Appendix

### package.json format

```json
{
  "straw": {
    "gulpfile": "cognitom:gulpfile.coffee",
    "task/css": "cognitom:task/css.coffee"
  }
}
```