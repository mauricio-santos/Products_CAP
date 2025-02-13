namespace de.santos;

using {
    cuid, //automatically filled in
    managed //Aspect to capture changes by user and name
} from '@sap/cds/common';

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
    Width            : SalesData:Revenue;
    Depth            : Decimal(16, 2);
    Quantity         : Decimal(16, 2);
    Supplier         : Association to one Suppliers;
    UnitOfMeasure    : Association to UnitsOfMeasures; //o uso do "one" é opcional
    Currency         : Association to Currencies;
    DimensionUnit    : Association to DimensionsUnits;
    Category         : Association to Categories;
    SalesData        : Association to many SalesData
                           on SalesData.Product = $self;
    Reviews          : Association to many ProductReview
                           on Reviews.Product = $self;
};

entity Suppliers : cuid, managed {
    Name    : String;
    Address : Address;
    Email   : String;
    Phone   : String;
    Fax     : String;
    Product : Association to many Products
                  on Product.Supplier = $self;
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

entity UnitsOfMeasures {
    key ID          : String(2);
        Description : localized String;
};

entity DimensionsUnits {
    key ID          : String(2);
        Description : localized String;
};

entity Months {
    key ID               : String(2);
        Description      : localized String;
        ShortDescription : localized String(3);
};

entity ProductReview : cuid, managed {
    Name    : String;
    Rating  : String;
    Comment : String;
    Product : Association to Products;
};

entity SalesData : cuid, managed {
    DeliveryDate  : DateTime;
    Revenue       : Decimal(16, 2);
    Product       : Association to Products;
    Currency      : Association to Currencies;
    DeliveryMonth : Association to Months;
};

// ------ VISTAS E PROJEÇÕES ------
entity SelectProductsAll1       as select from Products;

entity SelectProductsAll2       as
    select from Products {
        *
    };

entity SelectProductsSimple     as
    select from Products {
        Name,
        Price,
        Quantity
    };

entity SelectProductsJoin       as
    select from Products
    left join ProductReview
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

// COMPOSIÇÃO - Relação Todo-Parte
// Ao remover Orders, o OrdeItems também será eliminado.
entity Orders : cuid {
    Date     : DateTime;
    Customer : String;
    Item     : Composition of many OrderItems
                   on Item.Order = $self;
};

entity OrderItems : cuid {
    Order    : Association to Orders;
    Product  : Association to Products;
    Quantity : Integer;
};
