pageextension 60176 SalesReturnOrder extends "Sales Return Order"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(GSSTeam; Rec.GSSTeam)
            {
                ApplicationArea = all;
            }
            field("Reason For Retun"; Rec."Reason For Retun")
            {
                ApplicationArea = all;
            }
        }

        addafter(Status)
        {
            field(Amount; Amount)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}