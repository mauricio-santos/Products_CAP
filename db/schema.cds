namespace de.santos;

using {cuid} from '@sap/cds/common'; //automatically filled in


// ----- TIPO PERSONALIZADOS -----
// type CustomType : String(50); //não recomendado. Utilizar tipos padrões do CDL

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

// ----- TIPO ARRAY -----
// type EmailsAddresses_01 : array of { //"array of" pode ser substituido por "many"
//     kind  : String;
//     email : String;
// };

// type EmailsAddresses_02 {
//     kind  : String;
//     email : String;
// };

// entity Emails { //Em DB tem o typo NCLOB
//     email_01 :      EmailsAddresses_01; // Declarando array ja declarado
//     email_02 : many EmailsAddresses_02; //Declarando Array utilizando um tipo personalizado
//     email_03 : many { //Declarando o array diretamente na entidade
//         kind  : String;
//         email : String;
//     };
// }

// ----- ENUMERAÇÕES -----
// type Gender     : String enum {
//     Male;
//     Female;
// };

// entity Order {
//     ClientGender : Gender;
//     Status       : Integer enum {
//         Submitted  = 1;
//         Fullfiller = 2;
//         Shipped    = 3;
//         Cancel     = -1
//     };
//     Priority     : String @assert.range enum { // @assert.range é uma anotação que define um intervalo de valores
//         Height;
//         Medium;
//         Low;
//     }
// };

// ----- ELEMENTOS VIRTUAIS -----
// entity Cars {
//     key ID                 : UUID;
//         Name               : String;
//         // ativa o Core.Computed no XML, fazendo que o este atributo seja somente leitura
//         virtual Discount_1 : Decimal; // <Annotation Term="Core.Computed" Bool="false"/>

//         @Core.Computed: false // Ativa a escrita dos dados
//         virtual Discount_2 : Decimal; //<Annotation Term="Core.Computed" Bool="true"/>

// // Valor padrão quando não tem o atributo virtual: <Annotation Term="Core.ComputedDefaultValue" Bool="true"/>
// };

entity Products : cuid {
    // key ID               : UUID;
    Name             : String not null; //default 'NoName';
    Description      : String;
    ImageUrl         : String;
    ReleaseDate      : DateTime default $now;
    DiscontinuedDate : DateTime;
    Price            : Decimal(16, 2);
    Height           : type of Price;
    Width            : SalesData:Revenue;
    Depth            : Decimal(16, 2);
    Quantity         : Decimal(16, 2);
    Supplier         : Association to one Suppliers;
    UnitsOfMeasures  : Association to UnitsOfMeasures; //o uso do "one" é opcional
    Currency         : Association to Currencies;
    DimensionUnit    : Association to DimensionsUnits;
    Category         : Association to Categories;
    SalesData        : Association to many SalesData
                           on SalesData.Product = $self;
    Reviews          : Association to many ProductReview
                           on Reviews.Product = $self;
};

entity Suppliers : cuid {
    Name    : String;
    Address : Address;
    Email   : String;
    Phone   : String;
    Fax     : String;
    Product : Association to many Products
                  on Product.Supplier = $self;
};

entity Categories : cuid {
    key ID   : String(1);
        name : String;
};

entity StockAvailability : cuid {
    key ID          : Integer;
        Description : String;
};

entity Currencies : cuid {
    key ID          : String(3);
        Description : String;
};

entity UnitsOfMeasures {
    key ID          : String(2);
        Description : String;
};

entity DimensionsUnits {
    key ID          : String(2);
        Description : String;
};

entity Months {
    key ID               : String(2);
        Description      : String;
        ShortDescription : String(3);
};

entity ProductReview : cuid {
    Name    : String;
    Rating  : String;
    Comment : String;
    Product : Association to Products;
};

entity SalesData : cuid {
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

// ENTIDADE COM PARÂMETROS - Não funciona com SQL, somente em HANA DB
// entity ParameterProducts(pName : String) as
//     select from Products {
//         Name,
//         Price,
//         Quantity
//     }
//     where
//         Name = :pName; //chamando o parâmetro

// entity ProjParamProducts(pName : String) as projection on Products
//                                             where
//                                                 Name = :pName;

// EXTENSÃO DE ENTIDADES
extend Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);
};

// ASSOCIAÇÃO Many to Many

//Muitos-para-Muitos não pode ser representado diretamente em algumas linguagens de modelagem de dados,
//então é necessário usar uma entidade intermediária (StudentCourse).

entity Course : cuid { // um curso pode ter vários registros na tabela intermediária StudentCourse.
    Student : Association to many StudentCourse
                  on Student.Course = $self;

};

entity Student : cuid { // um estudante pode ter múltiplos registros na tabela intermediária.
    Course : Association to many StudentCourse
                 on Course.Student = $self;
};

entity StudentCourse : cuid { // Esta entidade representa a associação muitos-para-muitos entre Student e Course
    Course  : Association to Course;
    Student : Association to Student;
};

// COMPOSIÇÃO - Relação Todo-Parte
// Ao remover Orders, o OrdeItems também será eliminado.
entity Orders : cuid {
    Date     : DateTime;
    Customer : String;
    Item     : Composition of many OrderItems
                   on Item.Order = $self;
// Item     : Composition of many { //Forma direta
//                key Position : Integer;
//                    Order    : Association to Orders;
//                    Product  : Association to Products;
//                    Quantity : Integer;
//            };
};

entity OrderItems : cuid {
    Order    : Association to Orders;
    Product  : Association to Products;
    Quantity : Integer;
};
