# Gulp Straw

The command-line tool to manage your `gulpfile`.
`gulpfile` is a task file for [gulp.js](http://gulpjs.com).

## What Straw does:

- install `gulpfile` from GitHub
- update `gulpfile` from GitHub
- publish `gulpfile` to GitHub
- solve the dependencies on `package.json`

## Install

### Install `gulp-straw` globally

```bash
$ npm install -g gulp-straw
```

### Set your GitHub account


## Usage

### Install gulpfiles

#### Get gulpfiles from your repository

```bash
$ cd ./path/to/project/
$ straw install gulpfile
$ straw install task/css
```

#### Get gulpfiles from others

```bash
$ straw install cognitom/gulpfiles:gulpfile
$ straw install cognitom/gulpfiles:task/css
```

If the repository name is ommited `straw` guess that the name would be `gulpfile`. So these command can also be written like below.

```bash
$ straw install cognitom:gulpfile
$ straw install cognitom:task/css
```

You don't have

#### Install all specified in `package.json`

```bash
$ straw install
```

### Update gulpfiles

#### Update all specified in `package.json`

```bash
$ straw update
```

#### Update gulpfiles

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