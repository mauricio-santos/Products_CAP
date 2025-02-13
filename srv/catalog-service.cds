using {de.santos as santos} from '../db/schema';


service CatalogService {
    entity Products      as projection on santos.Products;
    entity Suppliers     as projection on santos.Suppliers;
    entity Currency      as projection on santos.Currencies;
    entity UnitOfMeasure as projection on santos.UnitsOfMeasures;
    entity DimensionUnit as projection on santos.DimensionsUnits;
    entity Month         as projection on santos.Months;
    entity Category      as projection on santos.Categories;
    entity SalesData     as projection on santos.SalesData;
    entity Reviews       as projection on santos.ProductReview;
    entity Order         as projection on santos.Orders;
    entity OrderItem     as projection on santos.OrderItems;

};
