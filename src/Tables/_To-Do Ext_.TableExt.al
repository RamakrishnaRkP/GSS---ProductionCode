tableextension 60134 "To-Do Ext" extends "To-do"
{
    fields
    {
        field(60100; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(60101; "Pre-Sales Person"; Code[20])
        {
            Caption = 'Pre-SalesPerson';
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
        }
        field(60102; "Pre-SalesPerson Name"; Text[30])
        {
            Caption = 'Pre-SalesPerson Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No."=field("Pre-Sales Person")));
        }
    }
}
