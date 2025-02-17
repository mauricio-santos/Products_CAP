using CatalogService as service from '../../srv/catalog-service';

annotate service.Products with @(

    Capabilities: {
        DeleteRestrictions : { // Ativando/Desativando função de deleção de produtos
            $Type : 'Capabilities.DeleteRestrictionsType',
            Deletable: false
        },
    },

    UI.HeaderInfo                : {
        TypeName      : '{i18n>Product}',
        TypeNamePlural: '{i18n>Products}',
        ImageUrl      : ImageUrl,
        Title         : {Value: ProductName},
        Description   : {Value: Description}
    },

    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Description}',
                Value: Description,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>ReleaseDate}',
                Value: ReleaseDate,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>DiscontinuedDate}',
                Value: DiscontinuedDate,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Price}',
                Value: Price,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Height}',
                Value: Height,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Width}',
                Value: Width,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Depth}',
                Value: Depth,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Quantity}',
                Value: Quantity,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>UnitOfMeasure}',
                Value: ToUnitOfMeasure_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Currency}',
                Value: ToCurrency_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>CategoryId}',
                Value: ToCategory_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>Category}',
                Value: Category,
            },
            {
                $Type: 'UI.DataField',
                Label: '{i18n>DimensionUnitID}',
                Value: ToDimensionUnit_ID,
            },
            {
                // $Type: 'UI.DataField',
                $Type : 'UI.DataFieldForAnnotation',
                Label : '{i18n>Rating}',
                // Value: Rating,
                Target: '@UI.DataPoint#AverageRating'

            },
            {
                $Type: 'UI.DataField',
                Label: 'StockAvailability',
                Value: StockAvailability,
            },
        ],
    },

    UI.Facets                    : [ //Seccions
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet',
            Label : '{i18n>GeneralInformation}',
            Target: '@UI.FieldGroup#GeneratedGroup',
        }, 
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet2',
            Label : '{i18n>GeneralInformationCopy}',
            Target: '@UI.FieldGroup#GeneratedGroup',
        }
    ],

    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.DataPoint#AverageRating'
        }
    ],

    UI.LineItem                  : [ //Filtros predefinidos
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ImageUrl}',
            Value: ImageUrl,
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ProductName}',
            Value: ProductName,
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>DescriptionProduct}',
            Value: Description,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>Supplier}',
            Target: 'Supplier/@Communication.Contact',
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>ReleaseDate}',
            Value: ReleaseDate,
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>DiscontinuedDate}',
            Value: DiscontinuedDate,
        },
        {
            $Type      : 'UI.DataField',
            Label      : '{i18n>StockAvailability}',
            Value      : StockAvailability,
            Criticality: StockAvailability
        },
        {
            // $Type : 'UI.DataField',
            $Type : 'UI.DataFieldForAnnotation',
            Label : '{i18n>Rating}',
            // Value : Rating,
            Target: '@UI.DataPoint#AverageRating'
        },
        {
            $Type: 'UI.DataField',
            Label: '{i18n>Price}',
            Value: Price,
        },
    ],
    UI.SelectionFields           : [ //Compos de Seleção
        ToCategory_ID,
        ToCurrency_ID,
        StockAvailability
    ]
);

annotate service.Products with { // Textos dos campos de filtro
    ToCategory   @title : '{i18n>CategoryId}';
    ToCurrency   @title : '{i18n>CurrencyId}';
    StockAvailability @title : '{i18n>StockAvailability}';
};

annotate service.Products with {
    Supplier @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Supplier',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Supplier_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Name',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Email',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Phone',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Fax',
            },
        ],
    }
};

// AJUDA DE BUSCA
annotate service.Products with {
    //Category
    ToCategory        @(Common: {
        Text     : {
            $value                : Category,
            ![@UI.TextArrangement]: #TextOnly,
        },
        ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Categories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCategory_ID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCategory_ID,
                    ValueListProperty: 'Text'
                }
            ]
        },
    });

    //Currency
    ToCurrency        @(Common: {
        ValueListWithFixedValues: false, //Ativa/Desativa Drop-Down List
        ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'VH_Currencies',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ToCurrency_ID,
                    ValueListProperty: 'Code'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'Text'
                }
            ]
        },
    });

    //StockAvailibility
    StockAvailability @(Common: {
        ValueListWithFixedValues: true, //Ativa Drop-Down List
        ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'StockAvailability',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: StockAvailability,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: StockAvailability,
                    ValueListProperty: 'Description'
                }
            ]
        },
    });

};


/**
 * Annotation for VH_Categories Entity
 */
annotate service.VH_Categories with {
    Code @(
        UI    : {Hidden: true},
        Common: {Text: {$value: 'Text'}}
    );
    Text @(UI: {HiddenFilter: true});
};

/**
 * Annotation for VH_CurrencyEntity
 */
annotate service.VH_Currencies {
    Code @(UI: {HiddenFilter: true});
    Text @(UI: {HiddenFilter: true});
};

/**
* Annotation for StockAvailability
*/
annotate service.StockAvailability {
    ID @(Common: {Text: {
        $value                : Description,
        ![@UI.TextArrangement]: #TextOnly
    }})
};

/**
* Annotation for VH_UnitOfMeasure Entity
*/
annotate service.VH_UnitOfMeasure {
    Code @(UI: {HiddenFilter: true});
    Text @(UI: {HiddenFilter: true});
};

/**
* Annotation for VH_DimensionUnits Entity
*/
annotate service.VH_DimensionUnits {
    Code @(UI: {HiddenFilter: true});
    Text @(UI: {HiddenFilter: true});
};

annotate service.Products with {
    ImageUrl @(UI.IsImageURL: true)
};

/**
* Annotation for Supplier Entity - Communication Contact
*/
annotate service.Supplier with @(Communication: {Contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    role : 'Supplier Role',
    photo: 'sap-icon://supplier',
    email: [{
        type   : #work,
        address: Email
    }, ],
    tel  : [
        {
            type: #work,
            uri : Phone
        },
        {
            type: #fax,
            uri : Fax
        }
    ]
}});

/**
* Annotation for Average Rating
*/
annotate service.Products with @(
    UI.DataPoint #AverageRating: {
        Value: Rating,
        Title: '{i18n>Rating}',
        TargetValue: 5,
        Visualization: #Rating
    }
);