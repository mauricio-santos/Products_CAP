using {de.santos as santos} from '../db/schema';


service CatalogService {
    entity Products      as projection on santos.Products;
    entity Suppliers     as projection on santos.Suppliers;
    entity Currency      as projection on santos.Currencies;
    entity DimensionUnit as projection on santos.DimensionsUnits;
    entity Category      as projection on santos.Categories;
    entity SalesData     as projection on santos.SalesData;
    entity Reviews       as projection on santos.ProductReview;
};
