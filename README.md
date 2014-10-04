# Gulp Straw (experimental)

Gulp Task Manager: The command-line tool for managing your `gulpfile`. `gulpfile` is a task file for [gulp.js](http://gulpjs.com).

Usually `gulpfile` grows bigger and bigger, so it's strongly recommended to split it and make it reusable. How? Use this `straw`!

## Features

- retrieve `gulpfile` from your (or other's) GitHub repo
- install dependencies automatically

and now implementing the features below.

- update `gulpfile` from GitHub
- publish `gulpfile` to GitHub

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

At the first, prepare your [gulpfiles repository like this](https://github.com/cognitom/gulpfiles).

### Install gulpfiles

Go to your project directory.

```bash
$ cd ./path/to/project/
```

Get gulpfiles from your repository:

```bash
$ straw install gulpfile
$ straw install task/css
```

Or it's ok to set multiple tasks.

```bash
$ straw install gulpfile task/css
```

#### Custom directory

If you have a task `coffee` but you want to install it under the `task` directory, use `--dir` option.

```bash
$ straw install coffee --dir task/
```

#### Get gulpfiles from others

```bash
$ straw install cognitom/gulpfiles:gulpfile
$ straw install cognitom/gulpfiles:task/css
```

If the repository name is ommited `straw` guess that the name would be `gulpfiles`. So these command can also be written like below.

```bash
$ straw install cognitom:gulpfile
$ straw install cognitom:task/css
```

#### Install all

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
    "gulpfile": "cognitom:gulpfile",
    "task/css": "cognitom:task/css"
  }
}
```

## Todos:

- [x] introduce [commander.js](http://visionmedia.github.io/commander.js/)
- [x] get file from GitHub repo by [octonode](http://visionmedia.github.io/commander.js/)
- [x] save config into package.json
- [x] auto-complete extension: `.js` or `.coffee` or ...
- [x] install multi tasks
- [x] install all from package.json
- [x] add devDependency automatically
- [ ] modify relative paths in gulpfiles
- [ ] update task
- [ ] publish task
- [ ] uninstall task
- [ ] support private repo
- [ ] error handling
- [ ] test test test
