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

## Processus de Build et Affichage

### Génération complète des exemples (v2)
- Exécutez les commandes suivantes pour scraper, générer et builder :
  1. `ruby build_categories.rb build_v2` : Scrape la structure depuis phaser.io vers `civet_examples_v2/`.
  2. Pour chaque YAML : `ruby build_categories.rb scrape_examples civet_examples_v2/{category}/{category}.yml` : Télécharge les assets (images et JS).
  3. `ruby build_categories.rb generate_category_pages` : Génère les pages de catégories hiérarchiques dans `jekyll/_categories/`.
  4. `ruby build_categories.rb generate_example_pages` : Génère les pages d'exemples dans `jekyll/_examples/`.
  5. `cd jekyll && bundle exec jekyll build` : Build le site Jekyll.
- Lancez Jekyll avec `jekyll serve` dans `jekyll/` pour voir l'app (catégories via `/categories/slug`, exemples via `/examples/category/slug`).

### Régénération d'un exemple spécifique
- Pour régénérer un seul exemple (ex. `civet_examples/animation/1057.civet`) :
  1. Compilez manuellement : `civet -c civet_examples/animation/1057.civet -o jekyll/js/builded_examples/animation/1057.js`
  2. Si la page `.md` n'existe pas, créez-la manuellement dans `jekyll/_examples/1057.md` avec front matter (voir exemples existants).
  3. Relancez Jekyll pour voir les changements.
- Si le script de build est modifié, relancez `./build_examples.sh` pour tout régénérer.

### Conversion JS vers Civet
- Utilisez `node transform.js` pour transformer des fichiers JS en syntaxe Civet (appliqué récursivement aux `.civet` dans `civet_examples/`).
- Utile pour importer de nouveaux exemples JS et les convertir.

### Débogage
- Vérifiez les erreurs de compilation Civet dans la console lors du build.
- Assurez-vous que les layouts Jekyll (`jekyll/_layouts/example.html`) incluent le JS compilé correctement.
- Note: Les layouts sont en Liquid/HTML. Slim n'était pas compatible avec Jekyll.