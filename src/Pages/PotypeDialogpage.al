page 60195 "PO Type Dialog"
{
    PageType = StandardDialog;
    Caption = 'Select PO Type';

    layout
    {
        area(Content)
        {
            field(POType; POType)
            {
                ApplicationArea = All;
                Caption = 'PO Type';
            }
        }
    }

    var
        POType: Enum "PO Type";

    procedure GetPOType(): Enum "PO Type"
    begin
        exit(POType);
    end;

    procedure SetPOType(NewPOType: Enum "PO Type")
    begin
        POType := NewPOType;
    end;
}