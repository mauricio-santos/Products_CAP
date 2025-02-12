using {de.santos as santos} from '../db/schema';


service CatalogService {
    entity Products_SRV        as projection on santos.Products;
    entity Suppliers_SRV       as projection on santos.Suppliers;
    entity UnitsOfMeasures_SRV as projection on santos.UnitsOfMeasures;
};
