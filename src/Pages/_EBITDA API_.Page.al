page 60106 "EBITDA API"
{
    PageType = API;
    Caption = 'EBITDAAPI';
    APIPublisher = 'GSS';
    APIGroup = 'EBITDAAPI';
    APIVersion = 'v1.0';
    EntityName = 'EBITDAAPI';
    EntitySetName = 'EBITDAAPI';
    SourceTable = Date;
    SourceTableView = where("Period Type"=const(Month));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Amounts)
            {
                field(MonthName; Rec."Period Name")
                {
                    ApplicationArea = All;
                }
                field(Amount;(GLAmount * -1))
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        GLEntryRec: Record "G/L Entry";
        EbitdaAcctsRec: Record "GSS EBITDA GL Accounts";
    begin
        Clear(GLAmount);
        //EbitdaAcctsRec.SetFilter("Account No.", '<>%1', '');
        //  if EbitdaAcctsRec.FindSet() then
        //  repeat
        GLEntryRec.Reset();
        GLEntryRec.SetRange("Posting Date", Rec."Period Start", Rec."Period End");
        GLEntryRec.SetFilter("G/L Account No.", EbitdaAccts);
        GLEntryRec.CalcSums(Amount);
        // repeat
        GLAmount+=GLEntryRec.Amount;
    // until GLEntryRec.Next() = 0;
    // until EbitdaAcctsRec.Next() = 0;
    end;
    trigger OnInit()
    var
        NewStartDate: Text;
        NewEndDate: Text;
        CurrentYear: Integer;
        StartingDate: Date;
        EndingDate: Date;
    begin
        //NewStartDate := CalcDate()
        Clear(EbitdaAccts);
        EbitdaAcctsRec.SetFilter("Account No.", '<>%1', '');
        if EbitdaAcctsRec.FindSet()then repeat if EbitdaAccts = '' then EbitdaAccts:=EbitdaAcctsRec."Account No."
                else
                    EbitdaAccts:=EbitdaAccts + '|' + EbitdaAcctsRec."Account No.";
            until EbitdaAcctsRec.Next() = 0;
        CurrentYear:=Date2DMY(Today, 3);
        NewStartDate:='0101' + '2024' + 'D';
        //   NewEndDate := '0101' + Format(CurrentYear) + 'D';
        //  NewEndDate := Format(Date2DMY(CalcDate('<CM>', Today()), 2))
        if evaluate(StartingDate, NewStartDate)then;
        //if Evaluate(EndingDate, NewEndDate) then;
        SetRange("Period Start", StartingDate, CalcDate('<CM>', Today()));
    end;
    var GLAmount: Decimal;
    EbitdaAcctsRec: Record "GSS EBITDA GL Accounts";
    EbitdaAccts: Text;
}
