export const config = {
  corge: {
    grault: {
      garply: process.env.ROOT__CORGE__GRAULT__GARPLY
    }
  },
  foo: {
    bar: process.env.ROOT__FOO__BAR,
    qux: process.env.ROOT__FOO__QUX
  },
  fred: process.env.ROOT__FRED,
  one: [
    {
      two: process.env.ROOT__ONE__0__TWO
    },
    {
      four: process.env.ROOT__ONE__1__FOUR
    }
  ],
  someThing: {
    another: process.env.ROOT__SOME_THING__ANOTHER
  },
  verbatimUpper: {
    verbatimProp: "someString"
  }
}