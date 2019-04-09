# svgen

[![npm](https://img.shields.io/npm/v/@nonbili/svgen.svg)](https://www.npmjs.com/package/@nonbili/svgen)

## Usage

```
yarn add @nonbili/svgen
yarn svgen -h
```

## Example

```
node index.js  -F example/svg -o ./example/src/Icons.purs --svgo-config ./example/svgo.config.json
cd example
yarn
pulp build
yarn start
```
