codeunit 60107 "GSSValdiation"
{
    trigger OnRun()
    begin
    end;
    var myInt: Integer;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ATOS Item Class", 'OnAfeterValidateItemForRelease', '', false, false)]
    local procedure OnAfeterValidateItemForRelease(var Item: Record Item)
    begin
        Item.TestField("Global Dimension 1 Code");
        Item.TestField("Global Dimension 2 Code");
        if Item.Type = Item.Type::Inventory then Item.TestField("Item Tracking Code");
        Item.TestField("Manufacturer Code");
    end;
}
