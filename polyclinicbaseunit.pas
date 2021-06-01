unit PolyclinicBaseUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  StdCtrls, ExtCtrls, Lists, DateTimePicker;

type

  { TForm1 }

  TForm1 = class(TForm)
    BAdd: TButton;             //Кнопка создания Узла
    BSearch: TButton;          //Кнопка поиска
    BExportReport: TButton;    //Кнопка Экспорта
    BDelete: TButton;          //Кнопка Удаления
    FieldDateR: TComboBox;     //Даты для удаления
    FieldDoctor: TComboBox;
    L16num: TLabel;
    Label2: TLabel;
    MIExportTxt: TMenuItem;
    MIExportCSV: TMenuItem;
    MenuItemHelp: TMenuItem;
    MIAddInBase: TMenuItem;
    MIRemoveList: TMenuItem;
    MIList: TMenuItem;
    BView: TButton;
    InputGroupBoxRadio: TGroupBox;
    OutputAnswerR: TLabel;
    OutputAddStatus: TLabel;
    OutputMemo: TMemo;
    MIExport: TMenuItem;
    FieldNameR: TLabeledEdit;
    FieldSurnameR: TLabeledEdit;
    FieldPatronymicR: TLabeledEdit;
    FieldPolicyNumberR: TLabeledEdit;
    RadioName: TRadioButton;
    RadioPolicyNumber: TRadioButton;
    SaveDSaveReport: TSaveDialog;
    PRemoveNode: TTabSheet;
    FieldTime: TDateTimePicker;
    TimeLable: TLabel;
    FieldPolicyNumber: TLabeledEdit;
    FieldName: TLabeledEdit;
    FieldSurname: TLabeledEdit;
    FieldPatronymic: TLabeledEdit;
    FieldCBSortBox: TComboBox;
    DoctorLable: TLabel;
    MainMenu: TMainMenu;
    MIFiles: TMenuItem;
    MenuItemOpen: TMenuItem;
    MISave: TMenuItem;
    OpenDOpenDB: TOpenDialog;
    Pages: TPageControl;
    SaveDSaveBase: TSaveDialog;
    PAddNodeInBase: TTabSheet;
    PViewReport: TTabSheet;
    procedure BAddClick(Sender: TObject); //comment
    procedure BDeleteClick(Sender: TObject);
    procedure BSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);   //comment
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MIAddInBaseClick(Sender: TObject);
    procedure MIExportCSVClick(Sender: TObject);
    procedure MIExportTxtClick(Sender: TObject);
    procedure MIFilesClick(Sender: TObject);    //comment
    procedure MISaveClick(Sender: TObject);
    procedure MIListClick(Sender: TObject);
    procedure MIRemoveListClick(Sender: TObject);
    procedure PagesChange(Sender: TObject);
    procedure RadioNameChange(Sender: TObject);
    procedure RadioPolicyNumberChange(Sender: TObject);
    procedure BViewClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  base:TBase;
  Report:TextFile;
  first, Node:TNode;
  MF:Boolean;
  T: array of TDateTime;

procedure CheckNodeName();
procedure CheckNodePolic();

implementation

{$R *.lfm}

{ TForm1 }

procedure CheckNodeName();
var iter : TNode; Time: string;
begin
iter:=first;
Form1.FieldDateR.Items.Clear;
while (iter <> nil) do begin
   if (iter = nil) then break
   else
     if (iter^.obj.Name = Form1.FieldNameR.Text)
     and (iter^.obj.Surname = Form1.FieldSurnameR.Text)
     and (iter^.obj.Patronymic = Form1.FieldPatronymicR.Text)
     then
       begin
         DateTimeToString(Time, 'h:m',iter^.obj.Time);
         Form1.FieldDateR.Items.Add(Time);
       end;
iter := iter^.next;
end;
end;

procedure CheckNodePolic();
var iter : TNode; Time: string;
begin
iter:=first;
Form1.FieldDateR.Items.Clear;
while (iter <> nil) do begin
  if (iter = nil) then break else
    if (iter^.obj.PolicyNumber = Form1.FieldPolicyNumberR.Text)
     then
       begin
         DateTimeToString(Time, 'h:m',iter^.obj.Time);
         Form1.FieldDateR.Items.Add(Time);
       end;
iter := iter^.next;
end;
end;

procedure TForm1.MISaveClick(Sender: TObject);
begin
  if MF then
  begin
    if not SaveDSaveBase.Execute then exit;
    AssignFile(base,SaveDSaveBase.FileName);
    Rewrite(base);
    WriteListInBase(first,base);
    SaveDSaveBase.Free;
    Closefile(base);
  end
  else ShowMessage('Не создана не одна запись');
end;

procedure TForm1.MIListClick(Sender: TObject);
begin
  if MF then
  begin
    MIRemoveList.Enabled:=True;
    MIAddInBase.Enabled:=True;
  end;
end;

procedure TForm1.MIRemoveListClick(Sender: TObject);
begin
  if MessageDlg('Вы действительно хотите удалить список? '+#13#10+'Вы можете еще сохранить сохранить перед удалением.',
  mtConfirmation,[mbYes,mbNo],0)=mrYes then
  begin
  RemoveList(first);
  MF:=False;
  OutputMemo.Lines.Clear;
  end;
end;

procedure TForm1.PagesChange(Sender: TObject);
begin
  if MF then begin
    BAdd.Caption:='Добавить';
    BSearch.Enabled:=True;
    BDelete.Enabled:=True;
    BView.Enabled:=True;
    MIAddInBase.Enabled:=True;
  end
  else begin
    BAdd.Caption:='Создать';
    BSearch.Enabled:=False;
    BDelete.Enabled:=False;
    BView.Enabled:=False;
  end;
end;

procedure TForm1.BAddClick(Sender: TObject);
var flag:Boolean; i_:integer;
begin

  flag:=False;

    if (FieldName.Text='')
  then FieldName.Color:=clRed
  else FieldName.Color:=clDefault;

    if (FieldSurname.Text='')
  then FieldSurname.Color:=clRed
  else FieldSurname.Color:=clDefault;

    if (FieldPatronymic.Text='')
  then FieldPatronymic.Color:=clRed
  else FieldPatronymic.Color:=clDefault;

  if (FieldDoctor.Text<>'DoctorField')
  then FieldDoctor.Color:=clDefault
  else FieldDoctor.Color:=clRed;

  if TryStrToInt(FieldPolicyNumber.Text,i_) and (Length(FieldPolicyNumber.Text) = 16)
  then FieldPolicyNumber.Color:=clDefault
  else FieldPolicyNumber.Color:=clRed;

  if (FieldName.Text='') or (FieldSurname.Text='') or (FieldPatronymic.Text='')
  or (FieldDoctor.Text='DoctorField') or (Length(FieldPolicyNumber.Text) <> 16)
  then OutputAddStatus.Caption:='Неправильный ввод'
  else flag:=True;


  if flag=True then
  begin
  New(Node);
  with Node^.obj do
      begin
        Name:=FieldName.Text;
        Surname:=FieldSurname.Text;
        Patronymic:=FieldPatronymic.Text;
        Time:=FieldTime.Time;
        Doctor:=FieldDoctor.Text;
        PolicyNumber:=FieldPolicyNumber.Text;
      end;
    Node^.next:=nil;
    Node^.prev:=nil;

    BuildLists(first,Node);
    MF:=True;
    OutputAddStatus.Caption:='Результат: Успешно.';
    BAdd.Caption:='Добавить';
  end else OutputAddStatus.Caption:='Результат: Ошибка.';
end;

procedure TForm1.BDeleteClick(Sender: TObject);
var iter,Riter : TNode; Time: string;
begin
  if FieldDateR.Caption='...' then OutputAnswerR.Caption:='Результат: Время не выбрано.';
  iter:=first;
  while (iter <> nil) do begin
    if (iter = nil) then break else
      if (iter^.obj.PolicyNumber = Form1.FieldPolicyNumberR.Text)
      or ((iter^.obj.Name = Form1.FieldNameR.Text)
     and (iter^.obj.Surname = Form1.FieldSurnameR.Text)
     and (iter^.obj.Patronymic = Form1.FieldPatronymicR.Text))
       then
         begin
           DateTimeToString(Time, 'h:m',iter^.obj.Time);
           if Time = FieldDateR.Caption then
             begin
             if iter=first then RemoveFirstNode(first,Riter) else
             RemoveNode(iter^.prev,Riter);
             OutputAnswerR.Caption:='Результат: Узел Удалён';
             end;
         end;
  iter := iter^.next;
  end;
end;

procedure TForm1.BSearchClick(Sender: TObject);
begin
  if MF then
  begin
    FieldDateR.Enabled:=True;
    BDelete.Enabled:=True;
    FieldDateR.Caption:='...';
    if RadioName.Checked then CheckNodeName else CheckNodePolic;
  end else ShowMessage('Не создана не одна запись');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MF:=False;
end;

procedure TForm1.MenuItemOpenClick(Sender: TObject);
var OBJ:TObj;
begin
  if not OpenDOpenDB.Execute then exit;
  AssignFile(base,OpenDOpenDB.FileName);
  Reset(base);
  while not Eof(base) do begin
    Read(base, OBJ);
    New(Node);
    Node^.obj:=OBJ;
    Node^.next:=nil;
    Node^.prev:=nil;
    BuildLists(first,Node);
    end;
  Closefile(base);
  MF:=True;
end;

procedure TForm1.MIAddInBaseClick(Sender: TObject);
begin
  if MF then
  begin
    if not SaveDSaveBase.Execute then exit;
    AssignFile(base,SaveDSaveBase.FileName);
    Reset(base);
    Seek(base,FileSize(base));
    WriteListInBase(first,base);
    //SaveDSaveBase.Free;
    Closefile(base);
  end
  else ShowMessage('Не создана не одна запись');
end;

procedure TForm1.MIExportCSVClick(Sender: TObject);
var  p:TNode; fOBJ:TObj; line,Time:string;
begin
  if MF then begin
    if not SaveDSaveReport.Execute then exit;
    AssignFile(Report,SaveDSaveReport.FileName);
    Rewrite(Report);
    Writeln(Report,Format('%s,%s,%s,%s,%s,%s',
    ['Name','Surname','Patronymic','Doctor','Time','PolicyNumber']));
    p:=first;
    while not(p=nil) do begin
      fOBJ:=p^.obj;
      DateTimeToString(Time, 'h:m',fOBJ.Time);
      line:=Format('"%s","%s","%s","%s",%s,%s',
      [fOBJ.Name, fOBJ.Surname, fOBJ.Patronymic,fOBJ.Doctor,Time,fOBJ.PolicyNumber]);
      Writeln(Report,line);
      p:=p^.next;
      end;
    Writeln(Report,' ');
    //SaveDSaveReport.Free;
    Closefile(Report);
  end
  else ShowMessage('Не создана не одна запись');
end;

procedure TForm1.MIExportTxtClick(Sender: TObject);
var  p:TNode; fOBJ:TObj; line,Time:string;
begin
  if MF then begin
    if not SaveDSaveReport.Execute then exit;
    AssignFile(Report,SaveDSaveReport.FileName);
    Append(Report);
    Writeln(Report,'База данных за сегодня');
    Writeln(Report,Format('|%-20s|%-20s|%-20s|%-40s|%-5s|%-16s|',
    ['Name','Surname','Patronymic','Doctor','Time','PolicyNumber']));
    p:=first;
    while not(p=nil) do begin
      fOBJ:=p^.obj;
      DateTimeToString(Time, 'h:m',fOBJ.Time);
      line:=Format('|%-20s|%-20s|%-20s|%-40s|%-5s|%-16s|',
      [fOBJ.Name, fOBJ.Surname, fOBJ.Patronymic,fOBJ.Doctor,Time,fOBJ.PolicyNumber]);
      Writeln(Report,line);
      p:=p^.next;
      end;
    Writeln(Report,' ');
    //SaveDSaveReport.Free;
    Closefile(Report);
  end
  else ShowMessage('Не создана не одна запись');
end;

procedure TForm1.MIFilesClick(Sender: TObject);
begin
  if MF=True then
  begin
    MISave.Enabled:=True;
    MIExport.Enabled:=True;
    MIAddInBase.Enabled:=True;
    MIRemoveList.Enabled:=True;
  end
  else
  begin
    MISave.Enabled:=False;
    MIExport.Enabled:=False;
    MIAddInBase.Enabled:=False;
    MIRemoveList.Enabled:=False;
  end
end;

procedure TForm1.RadioNameChange(Sender: TObject);
begin
  FieldPolicyNumberR.Enabled:=False;
  FieldNameR.Enabled:=True;
  FieldSurnameR.Enabled:=True;
  FieldPatronymicR.Enabled:=True;
end;

procedure TForm1.RadioPolicyNumberChange(Sender: TObject);
begin
  FieldPolicyNumberR.Enabled:=True;
  FieldNameR.Enabled:=False;
  FieldSurnameR.Enabled:=False;
  FieldPatronymicR.Enabled:=False;
end;

procedure TForm1.BViewClick(Sender: TObject);
var  p:TNode; fOBJ:TObj; line,Time:string;
begin
  if MF=true then
  begin
    OutputMemo.Lines.clear;
    OutputMemo.Lines.Add('База данных за сегодня');
    OutputMemo.Lines.Add(Format('|%-20s|%-20s|%-20s|%-40s|%-5s|%-16s|',
    ['Name','Surname','Patronymic','Doctor','Time','PolicyNumber']));
    if (FieldCBSortBox.Items[0] = FieldCBSortBox.Caption) then SortByDoctors(first)
    else if (FieldCBSortBox.Items[1] = FieldCBSortBox.Caption) then SortByTime(first)
         else if (FieldCBSortBox.Items[2] = FieldCBSortBox.Caption) then SortByTimeRev(first);
    p:=first;
    while not(p=nil) do begin
      fOBJ:=p^.obj;
      DateTimeToString(Time, 'h:m',fOBJ.Time);
      line:=Format('|%-20s|%-20s|%-20s|%-40s|%-5s|%-16s|',
      [fOBJ.Name, fOBJ.Surname, fOBJ.Patronymic,fOBJ.Doctor,Time,fOBJ.PolicyNumber]);
      OutputMemo.Lines.Add(line);
      p:=p^.next;
    end;
  end
  else ShowMessage('Не создана не одна запись');
end;

end.

