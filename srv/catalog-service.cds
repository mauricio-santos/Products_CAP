using {de.santos as santos} from '../db/schema';

service CatalogService {
    entity Products          as projection on santos.materials.Products;
    entity Category          as projection on santos.materials.Categories;
    entity StockAvailability as projection on santos.materials.StockAvailability;
    entity Currency          as projection on santos.materials.Currencies;
    entity UnitOfMeasure     as projection on santos.materials.UnitOfMeasures;
    entity DimensionUnit     as projection on santos.materials.DimensionUnits;
    entity Reviews           as projection on santos.materials.ProductReview;
    entity Suppliers         as projection on santos.sales.Suppliers;
    entity Order             as projection on santos.sales.Orders;
    entity OrderItem         as projection on santos.sales.OrderItems;
    entity SalesData         as projection on santos.sales.SalesData;
    entity Month             as projection on santos.sales.Months;
};
