namespace de.training;

using {
    cuid, //automatically filled in
} from '@sap/cds/common';

// ASSOCIAÇÃO Many to Many
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

// ----- TIPO PERSONALIZADOS -----
type CustomType         : String(50); //não recomendado. Utilizar tipos padrões do CDL

//-----TIPO array - ----
type EmailsAddresses_01 : array of { //"array of" pode ser substituido por "many"
    kind  : String;
    email : String;
};

type EmailsAddresses_02 {
    kind  : String;
    email : String;
};

entity Emails { //Em DB tem o typo NCLOB
    email_01 :      EmailsAddresses_01; // Declarando array ja declarado
    email_02 : many EmailsAddresses_02; //Declarando Array utilizando um tipo personalizado
    email_03 : many { //Declarando o array diretamente na entidade
        kind  : String;
        email : String;
    };
}

//-----ENUMERAÇÕES - ----

type Gender             : String enum {
    Male;
    Female;
};

entity Order {
    ClientGender : Gender;
    Status       : Integer enum {
        Submitted  = 1;
        Fullfiller = 2;
        Shipped    = 3;
        Cancel     = -1
    };
    Priority     : String @assert.range enum { // @assert.range é uma anotação que define um intervalo de valores
        Height;
        Medium;
        Low;
    }
};

//----- ELEMENTOS VIRTUAIS -----
entity Cars {
    key ID                 : UUID;
        Name               : String;
        // ativa o Core.Computed no XML, fazendo que o este atributo seja somente leitura
        virtual Discount_1 : Decimal; // <Annotation Term="Core.Computed" Bool="false"/>

        @Core.Computed: false // Ativa a escrita dos dados
        virtual Discount_2 : Decimal; //<Annotation Term="Core.Computed" Bool="true"/>

// Valor padrão quando não tem o atributo virtual: <Annotation Term="Core.ComputedDefaultValue" Bool="true"/>
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
