# Translation Rules for Phaser Examples to Civet

## General Guidelines
- Translate JavaScript code to Civet syntax while maintaining the original functionality.
- Even if prompts are in French, all comments in code files and all function or variable names must be in English.
- Ensure the translated code follows Civet conventions and best practices.

## Class Translation
- Write classes using Civet's class syntax, which allows for indented methods and properties.
- Do not use plain JavaScript class syntax; leverage Civet's enhancements for cleaner, more readable code.
- Example:
  ```civet
  class MyClass
    constructor(@param)
      // initialization
    method()
      // implementation
  ```

## Iteration Translation
- For iterations, use Civet's for loop styles, not CoffeeScript's.
- Use `for item of iterable` for iterating over arrays or iterables (equivalent to JavaScript's `for...of`).
- Use `for key in object` for iterating over object properties (equivalent to JavaScript's `for...in`).
- Avoid CoffeeScript's `for item in array` or `for key, value of object` syntax.
- Example:
  ```civet
  for item of array
    console.log item
  for key in object
    console.log key, object[key]
  ```

## Additional Notes
- Follow Civet's indentation and syntax rules to ensure the code compiles correctly.
- Test translations to verify they produce the expected output.
- Maintain code readability and add English comments where necessary to explain complex logic.