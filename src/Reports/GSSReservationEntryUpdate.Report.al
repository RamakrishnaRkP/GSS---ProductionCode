report 60122 GSSReservationEntryUpdate
{
    Caption = 'Reservation Entry Update';
    ProcessingOnly = true;
    Permissions = tabledata "Reservation Entry"=rimd;

    dataset
    {
        dataitem(ReservationEntry; "Reservation Entry")
        {
            trigger OnAfterGetRecord()
            begin
                if DeleteEntry then if ResvEntry.Get(ReservationEntry."Entry No.")then ResvEntry.Delete(true);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(DeleteEntry; DeleteEntry)
                    {
                        Caption = 'Delete Entry';
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var DeleteEntry: Boolean;
    ResvEntry: Record "Reservation Entry";
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        if ReservationEntry.GetFilter("Entry No.") = '' then Error('Entry No. fiter cannot be blank!');
        if not Confirm(StrSubstNo('Do you want to delete reservation entry: %1', ReservationEntry.GetFilter("Entry No."), false))then CurrReport.Quit();
    end;
    trigger OnPostReport()
    begin
        Message('Completed');
    end;
}
