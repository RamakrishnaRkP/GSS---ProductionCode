report 60116 "GSSJob Delivery Note V2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSS Job Delivery Note.rdl';
    Caption = 'Job Delivery Note';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Job Register"; "Job Register")
        {
            DataItemTableView = SORTING("No.")ORDER(Ascending);
            RequestFilterFields = "No.";

            column(CompName; CompInfo.Name)
            {
            }
            column(CompAddrese; CompInfo.Address + ' Tel :' + '  ' + CompInfo."Phone No." + ' Fax : ' + CompInfo."Fax No.")
            {
            }
            column(Picture; CompInfo.Picture)
            {
            }
            column(CompPhone; CompInfo."Phone No.")
            {
            }
            column(CompFax; CompInfo."Fax No.")
            {
            }
            column(DeliveryNo; "Job Register"."GSS Document No.")
            {
            }
            column(DeliveryDate; FORMAT("PostingDate", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(SalesOrderNo; "OrderNo")
            {
            }
            column(CustomerReference; "ExternalDocumentNo")
            {
            }
            column(Customername; "SelltoCustomerName")
            {
            }
            column(CustomerAddresse; Address)
            {
            }
            column(CustomerContact; Phone)
            {
            }
            column(ContactPerson; ContactPerson)
            {
            }
            column(CompanyShortcode; CompanyShortcode)
            {
            }
            dataitem(JobLedgerEntry; "Job Ledger Entry")
            {
                DataItemTableView = SORTING("Document No.", "Posting Date")ORDER(Ascending);

                /* 
                column(SlNo;"Sales Shipment Line"."Group Nos")
                {
                }
                */
                column(PartNo; JobLedgerEntry."No.")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(SerialNo; SerialNo)
                {
                }
                column(DoNotShow; DoNotShow)
                {
                }
                column(Description; Descr)
                {
                }
                /* itos comment
                column(ManfItemNo_SalesShipmentLine;"Sales Shipment Line"."Manf. Item No.")
                {
                }
                column(ManfItemDesc_SalesShipmentLine;"Sales Shipment Line"."Manf. Item Desc.")
                {
                }
                */
                trigger OnAfterGetRecord();
                begin
                    if JobLedgerEntry.Quantity = 0 then DoNotShow:=true
                    else
                        DoNotShow:=false;
                    SlNo:=SlNo + 1;
                    Descr:=Description;
                    //END;
                    SerialNo:='';
                    recILE.RESET;
                    recILE.SETRANGE(recILE."Document No.", JobLedgerEntry."Document No.");
                    recILE.SETRANGE(recILE."Item No.", JobLedgerEntry."No.");
                    recILE.SETFILTER(recILE."Serial No.", '<>%1', '');
                    if recILE.FINDFIRST then repeat if SerialNo = '' then SerialNo:=recILE."Serial No."
                            else
                                SerialNo:=SerialNo + ', ' + recILE."Serial No.";
                        until recILE.NEXT = 0;
                    if JobLedgerEntry.Quantity = 0 then CurrReport.SKIP;
                    if Job."No." = '' then if Job.Get(JobLedgerEntry."Job No.")then begin
                            SelltoCustomerName:=Job."Bill-to Name";
                            if JobLedgerEntry."External Document No." <> '' then ExternalDocumentNo:=JobLedgerEntry."External Document No."
                            else
                                ExternalDocumentNo:=Job."External Document No.";
                            PostingDate:=JobLedgerEntry."Posting Date";
                            OrderNo:=Job."No.";
                            if Cust.Get(job."Bill-to Customer No.")then begin
                                Address:=Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust.City;
                                Phone:=Cust."Phone No.";
                            end;
                        end;
                    if SerialNo <> '' then Descr:=Descr + '\' + SerialNo;
                end;
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    JobLedgerEntry.SetRange("Entry No.", "Job Register"."From Entry No.", "Job Register"."To Entry No.");
                end;
            }
            trigger OnPreDataItem();
            begin
                CalcFields("GSS Document No.");
            end;
            trigger OnAfterGetRecord();
            begin
            // Cust.RESET;
            // Cust.SETRANGE(Cust."No.", "Job Register"."Sell-to Customer No.");
            // if Cust.FINDFIRST then begin
            //     Addresse := Cust.Address + ' ' + Cust."Address 2" + ' ' + Cust.City;
            //     Phone := Cust."Phone No.";
            // end;
            // RecContact.RESET;
            // RecContact.SETRANGE(RecContact."No.", "Job Register"."Sell-to Contact No.");
            // if RecContact.FINDFIRST then
            //     ContactPerson := RecContact.Name;
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport();
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(CompInfo.Picture);
        CompanyShortcode:=CompInfo."GSSCompany Shortcode";
    end;
    var CompInfo: Record "Company Information";
    SlNo: Integer;
    Item: Record Item;
    Cust: Record Customer;
    CustContact: Code[50];
    ItemRec: Record Item;
    Descr: Text;
    Address: Text[250];
    RecContact: Record Contact;
    ContactPerson: Text[100];
    Phone: Code[50];
    recILE: Record "Item Ledger Entry";
    SerialNo: Text;
    DoNotShow: Boolean;
    CompanyShortcode: Text;
    Job: Record Job;
    PostingDate: Date;
    OrderNo: Code[30];
    ExternalDocumentNo: Code[35];
    SelltoCustomerName: Text[230];
}
