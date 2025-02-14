namespace de.santos;

using {
    cuid, //automatically filled in
    managed //Aspect to capture changes by user and name
} from '@sap/cds/common';

context materials {
    type Address {
        Street     : String;
        City       : String;
        State      : String(2);
        PostalCode : String(5);
        Country    : String(3);
    };

    entity Products : cuid, managed {
        Name             : localized String not null; //default 'NoName';
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Decimal(16, 2);
        Height           : type of Price;
        Width            : sales.SalesData:Revenue;
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to one sales.Suppliers;
        UnitOfMeasure    : Association to UnitOfMeasures; //o uso do "one" é opcional
        Currency         : Association to Currencies;
        DimensionUnit    : Association to DimensionUnits;
        Category         : Association to Categories;
        SalesData        : Association to many sales.SalesData
                               on SalesData.Product = $self;
        Reviews          : Association to many ProductReview
                               on Reviews.Product = $self;
    };

    entity Categories : cuid, managed {
        key ID   : String(1);
            Name : localized String;
    };

    entity StockAvailability : cuid {
        key ID          : Integer;
            Description : localized String;
            Product     : Association to Products;
    };

    entity Currencies : cuid {
        key ID          : String(3);
            Description : localized String;
    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : localized String;
    };

    entity DimensionUnits {
        key ID          : String(2);
            Description : localized String;
    };

    entity ProductReview : cuid, managed {
        Name    : String;
        Rating  : String;
        Comment : String;
        Product : Association to Products;
    };

    // PROJECTIONS NÃO SUPORTA JOIN.
    entity ProjectionProductsAll    as projection on Products;

    entity ProjectionProductsAll2   as
        projection on Products {
            *
        };

    entity ProjectionProductsSimple as
        select from Products {
            Name,
            ReleaseDate
        };

    // EXTENSÃO DE ENTIDADES
    extend Products with {
        PriceCondition     : String(2);
        PriceDetermination : String(3);
    };

};

context sales {
    entity Suppliers : cuid, managed {
        Name    : String;
        Address : materials.Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many materials.Products
                      on Product.Supplier = $self;
    };

    entity Orders : cuid {
        Date     : DateTime;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
    };

    entity OrderItems : cuid {
        Order    : Association to Orders;
        Product  : Association to materials.Products;
        Quantity : Integer;
    };

    entity SalesData : cuid, managed {
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to Months;
    };

    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(3);
    };

    // ------ VISTAS E PROJEÇÕES ------
    entity SelectProductsAll1   as select from materials.Products;

    entity SelectProductsAll2   as
        select from materials.Products {
            *
        };

    entity SelectProductsSimple as
        select from materials.Products {
            Name,
            Price,
            Quantity
        };

    entity SelectProductsJoin   as
        select from materials.Products
        left join materials.ProductReview
            on Products.Name = ProductReview.Name
        {
            Products.Name,
            Rating,
            sum(Price) as TotalPrice
        }
        group by
            Products.Name,
            Rating
        order by
            Rating;
};

context reports {
    entity AverageRating as
        select from santos.materials.ProductReview {
            Product.ID  as ProductId,
            avg(Rating) as AverageRating : Decimal(15, 2)
        }
        group by
            Product.ID;
};
