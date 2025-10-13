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

### Conversion JS vers Civet
- Utilisez `node transform.js` pour transformer des fichiers JS en syntaxe Civet (appliqué récursivement aux `.civet` dans `civet_examples/`).
- Utile pour importer de nouveaux exemples JS et les convertir.

### Débogage
- Vérifiez les erreurs de compilation Civet dans la console lors du build.
- Assurez-vous que les layouts Jekyll (`jekyll/_layouts/example.html`) incluent le JS compilé correctement.
- Note: Les layouts sont en Liquid/HTML. Slim n'était pas compatible avec Jekyll.

## Migration vers Bridgetown

### Vision du Projet
- Migrer le site Jekyll vers Bridgetown pour une meilleure performance et flexibilité (SSR, composants Ruby, etc.).
- Rendre l'index dynamique en utilisant `categories.yml` pour afficher toutes les catégories.
- Implémenter les catégories hiérarchiques récursives : pages parent affichant sous-catégories, feuilles affichant exemples.
- Utiliser des collections Bridgetown pour générer les pages de catégories et exemples dynamiquement.
- Extraire les composants en partials ERB pour réutilisabilité.
- Utiliser systématiquement la syntaxe .sass indentée pour tous les styles (plus concise et lisible que .scss). Placer les partials dans `src/_sass/lib/` (e.g., `_examples.sass`, `_variables.sass`). Le fichier principal `frontend/css/main.sass` importe depuis `_sass/lib/` avec `@import "_sass/lib/examples"`. Guard peut watcher pour rechargement automatique.

### Étapes de Migration
1. **Index dynamique :** Copier `categories.yml` vers `bridgetown/src/_data/`, modifier `index.erb` pour boucler sur `site.data.categories.categories`.
2. **Partials ERB :** Créer `src/_partials/_category_card.erb` pour les cards de catégories, inclus avec `<%= render "category_card", category: category %>`.
3. **Catégories hiérarchiques :**
   - Créer collection `categories` dans `bridgetown.config.yml` avec `output: true`.
   - Copier les MD de `jekyll/_categories/` vers `bridgetown/src/_categories/`.
   - Modifier `src/_layouts/category.erb` pour afficher sous-catégories si `is_leaf` false, sinon exemples.
   - Enrichir `categories.yml` avec hiérarchie (parent, sub_categories).
4. **Exemples dynamiques :** Créer collection `examples`, associer exemples via front matter (`category: slug`), modifier layout pour boucler sur exemples de la catégorie.
5. **Build et Serve :** `cd bridgetown && bridgetown build` puis `bridgetown serve` pour tester.

### Comparaison Jekyll vs Bridgetown
- Jekyll : MD statiques pour catégories, génération via scripts Ruby.
- Bridgetown : Collections dynamiques, ERB pour logique, composants Ruby pour complexité, organisation en `src/_sass/lib/` pour partials indentés, compatible Guard pour développement.
- Avantages Bridgetown : Progressive generation, meilleures performances, intégration Ruby native.