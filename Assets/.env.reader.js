export const config = {
  "corge" : {
    "grault" : {
      "garply": process.env.CORGE__GRAULT__GARPLY
    }
  },
  "foo" : {
    "bar": process.env.FOO__BAR,
    "qux": process.env.FOO__QUX
  },
  "fred": process.env.FRED,
  "one" : [
    {
      "two": process.env.ONE__0__TWO
    },
    {
      "four": process.env.ONE__1__FOUR
    }
  ],
  "someThing" : {
    "another": process.env.SOME_THING__ANOTHER
  }
}