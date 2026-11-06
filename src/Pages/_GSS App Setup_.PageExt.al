pageextension 60156 "GSS App Setup" extends "ATOS App Setup"
{
    actions
    {
        modify(ActionName)
        {
            Visible = false;
        }
        addfirst(Processing)
        {
            action("DeleteResvEntry")
            {
                ApplicationArea = All;
                Image = Delete;
                Caption = 'Delete Reservation Entry';
                RunObject = report GSSReservationEntryUpdate;
            }
            action("ExportILE-Update")
            {
                ApplicationArea = All;
                Caption = 'Export ILE for SNALL';
                Image = Export;

                trigger OnAction()
                var
                    IleXML: XmlPort GSSUpdateSerialLot;
                    ILE: Record "Item Ledger Entry";
                begin
                    Xmlport.Run(Xmlport::GSSUpdateSerialLot, true, false, ILE);
                end;
            }
            action("ImportILE-Update")
            {
                ApplicationArea = All;
                Caption = 'Import ILE for SNALL';
                Image = Import;

                trigger OnAction()
                var
                    IleXML: XmlPort GSSUpdateSerialLot;
                    ILE: Record "Item Ledger Entry";
                begin
                    Xmlport.Run(Xmlport::GSSUpdateSerialLot, true, true, ILE);
                end;
            }
            action("ImportJLE-Update")
            {
                ApplicationArea = All;
                Caption = 'Update Job Ledger Entry Unit Price';
                Image = Import;

                trigger OnAction()
                var
                    //JleXML: XmlPort GSSUpdateJobLedgerEntries;
                    JLE: Record "Job Ledger Entry";
                begin
                    Xmlport.Run(Xmlport::GSSUpdateJobLedgerEntries, true, true, JLE);
                end;
            }
            action(EnableLotSerialTracking)
            {
                ApplicationArea = All;
                Caption = 'Enable Lot - Serial Tracking';
                Image = Process;

                trigger OnAction()
                var
                    ItemTrackingCode: Record "Item Tracking Code";
                begin
                    if ItemTrackingCode.Get('SNALL')then if not ItemTrackingCode."SN Specific Tracking" then begin
                            ItemTrackingCode."SN Specific Tracking":=true;
                            ItemTrackingCode.Modify(false);
                        end;
                    if ItemTrackingCode.Get('LOTALL')then if not ItemTrackingCode."Lot Specific Tracking" then begin
                            ItemTrackingCode."Lot Specific Tracking":=true;
                            ItemTrackingCode.Modify(false);
                        end;
                end;
            }
        }
    }
}
