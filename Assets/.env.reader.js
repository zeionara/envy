export const config = {
  "corge" : {
    "grault" : {
      "garply": process.env.CORGE_GRAULT_GARPLY
    }
  },
  "foo" : {
    "bar": process.env.FOO_BAR,
    "qux": process.env.FOO_QUX
  },
  "fred": process.env.FRED,
  "one" : [
    {
      "two": process.env.ONE_0_TWO
    },
    {
      "four": process.env.ONE_1_FOUR
    }
  ]
}