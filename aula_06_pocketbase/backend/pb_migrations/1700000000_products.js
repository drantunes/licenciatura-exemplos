// Demonstração isolada: regras públicas. Não publicar esta configuração.
migrate((app) => {
  const collection = new Collection({
    name: 'products', type: 'base',
    listRule: '', viewRule: '', createRule: '', updateRule: '', deleteRule: '',
    fields: [{name: 'name', type: 'text', required: true}],
  });
  app.save(collection);
}, (app) => {
  app.delete(app.findCollectionByNameOrId('products'));
});
