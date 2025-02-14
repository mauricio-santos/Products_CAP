using {de.santos as santos} from '../db/schema';
// using { de.training as training} from '../db/training';

// service CatalogService {
//     entity Products          as projection on santos.materials.Products;
//     entity Category          as projection on santos.materials.Categories;
//     entity StockAvailability as projection on santos.materials.StockAvailability;
//     entity Currency          as projection on santos.materials.Currencies;
//     entity UnitOfMeasure     as projection on santos.materials.UnitOfMeasures;
//     entity DimensionUnit     as projection on santos.materials.DimensionUnits;
//     entity Reviews           as projection on santos.materials.ProductReview;
//     entity Suppliers         as projection on santos.sales.Suppliers;
//     entity Order             as projection on santos.sales.Orders;
//     entity OrderItem         as projection on santos.sales.OrderItems;
//     entity SalesData         as projection on santos.sales.SalesData;
//     entity Month             as projection on santos.sales.Months;
// };

service CatalogService {

    entity Products          as
        select from santos.materials.Products {
            // ID,
            // Name          as ProductName     @mandatory, //Obrigatório
            // Description                      @mandatory,
            // ImageUrl,
            // ReleaseDate,
            // DiscontinuedDate,
            // Price                            @mandatory,
            // Height,
            // Width,
            // Depth,
            *, //Todas as colunas anteriores são expostas
            Quantity,
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency      @mandatory,
            Category      as ToCategory      @mandatory,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews
        };

    @readonly
    entity Supplier          as
        select from santos.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Reviews           as
        select from santos.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly //Somente leitura (GET)
    entity SalesData         as
        select from santos.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        };

    @readonly
    entity StockAvailability as
        select from santos.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from santos.materials.Categories {
            ID   as Code,
            Name as Text
        };

    @readonly
    entity VH_Currencies     as
        select from santos.materials.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from santos.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_DimensionUnits as //Projeção Postfix
        select
            ID          as Code,
            Description as Text
        from santos.materials.DimensionUnits;
};
