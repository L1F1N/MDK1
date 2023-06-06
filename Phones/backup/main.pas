unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  Grids, StdCtrls, Edit;

type
  Knigi = record
    Kod: string[30];
    Name: string[40];
    Avtor: string[30];
    Janr: string[30];
    God: string[30];
  end; // record

type

  { TfMain }

  TfMain = class(TForm)
    Vugruz: TButton;
    Panel1: TPanel;
    bAdd: TSpeedButton;
    bEdit: TSpeedButton;
    bDel: TSpeedButton;
    bSort: TSpeedButton;
    SG: TStringGrid;
    procedure bAddClick(Sender: TObject);
    procedure bDelClick(Sender: TObject);
    procedure bEditClick(Sender: TObject);
    procedure bSortClick(Sender: TObject);
    procedure VugruzClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  fMain: TfMain;
  adres: string; //адрес, откуда запущена программа


implementation

{$R *.lfm}

{ TfMain }

procedure TfMain.bAddClick(Sender: TObject);
begin
  //очищаем поля, если там что-то есть:
  fEdit.eKod.Text:= '';
  fEdit.eName.Text:= '';
  fEdit.eAvtor.Text:= '';
  fEdit.eJanr.Text:= '';
  fEdit.eGod.Text:= '';
  //устанавливаем ModalResult редактора в mrNone:
  fEdit.ModalResult:= mrNone;
  //теперь выводим форму:
  fEdit.ShowModal;
  //если пользователь ничего не ввел - выходим:
  if (fEdit.eKod.Text= '') or (fEdit.eName.Text= '') or (fEdit.eAvtor.Text= '') or (fEdit.eJanr.Text= '') or (fEdit.eGod.Text= '') then exit;
  //если пользователь не нажал "Сохранить" - выходим:
  if fEdit.ModalResult <> mrOk then exit;
  //иначе добавляем в сетку строку, и заполняем её:
  SG.RowCount:= SG.RowCount + 1;
  SG.Cells[0, SG.RowCount-1]:= fEdit.eKod.Text;
  SG.Cells[1, SG.RowCount-1]:= fEdit.eName.Text;
  SG.Cells[2, SG.RowCount-1]:= fEdit.eAvtor.Text;
  SG.Cells[3, SG.RowCount-1]:= fEdit.eJanr.Text;
  SG.Cells[4, SG.RowCount-1]:= fEdit.eGod.Text;
end;

procedure TfMain.bDelClick(Sender: TObject);
begin
  //если данных нет - выходим:
  if SG.RowCount = 1 then exit;
  //иначе выводим запрос на подтверждение:
  if MessageDlg('Требуется подтверждение',
                'Вы действительно хотите удалить контакт "' +
                SG.Cells[0, SG.Row] + '"?',
    mtConfirmation, [mbYes, mbNo, mbIgnore], 0) = mrYes then
      SG.DeleteRow(SG.Row);
end;

procedure TfMain.bEditClick(Sender: TObject);
begin
  //если данных в сетке нет - просто выходим:
  if SG.RowCount = 1 then exit;
  //иначе записываем данные в форму редактора:
  fEdit.eKod.Text:= SG.Cells[0, SG.Row];
  fEdit.eName.Text:= SG.Cells[1, SG.Row];
  fEdit.eAvtor.Text:= SG.Cells[2, SG.Row];
  fEdit.eJanr.Text:= SG.Cells[3, SG.Row];
  fEdit.eGod.Text:= SG.Cells[4, SG.Row];
  //устанавливаем ModalResult редактора в mrNone:
  fEdit.ModalResult:= mrNone;
  //теперь выводим форму:
  fEdit.ShowModal;
  //сохраняем в сетку возможные изменения,
  //если пользователь нажал "Сохранить":
  if fEdit.ModalResult = mrOk then begin
    SG.Cells[0, SG.Row]:= fEdit.eKod.Text;
    SG.Cells[1, SG.Row]:= fEdit.eName.Text;
    SG.Cells[2, SG.Row]:= fEdit.eAvtor.Text;
    SG.Cells[3, SG.Row]:= fEdit.eJanr.Text;
    SG.Cells[4, SG.Row]:= fEdit.eGod.Text;
  end;
end;

procedure TfMain.bSortClick(Sender: TObject);
begin
  //если данных в сетке нет - просто выходим:
  if SG.RowCount = 1 then exit;
  //иначе сортируем список:
  SG.SortColRow(true, 3);
end;

procedure TfMain.VugruzClick(Sender: TObject);
var
  MyCont: Knigi; //для очередной записи
  f: file of Knigi; //файл данных
  i: integer; //счетчик цикла
begin
  if SG.RowCount = 1 then exit;
  //иначе открываем файл для записи:
  try
    AssignFile(f, adres + 'telephones.dat');
    Rewrite(f);
    //теперь цикл - от первой до последней записи сетки:
    for i:= 1 to SG.RowCount-1 do begin
      //получаем данные текущей записи:
      MyCont.Kod:= SG.Cells[0, i];
      MyCont.Name:= SG.Cells[1, i];
      MyCont.Avtor:= SG.Cells[2, i];
      MyCont.Janr:= SG.Cells[1, i];
      MyCont.God:= SG.Cells[2, i];
      //записываем их:
      Write(f, MyCont);
    end;
  finally
    CloseFile(f);
  end;
end;

procedure TfMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  MyCont: Knigi; //для очередной записи
  f: file of Knigi; //файл данных
  i: integer; //счетчик цикла
begin
  //если строки данных пусты, просто выходим:
  if SG.RowCount = 1 then exit;
  //иначе открываем файл для записи:
  try
    AssignFile(f, adres + 'telephones.dat');
    Rewrite(f);
    //теперь цикл - от первой до последней записи сетки:
    for i:= 1 to SG.RowCount-1 do begin
      //получаем данные текущей записи:
      MyCont.Kod:= SG.Cells[0, i];
      MyCont.Name:= SG.Cells[1, i];
      MyCont.Avtor:= SG.Cells[2, i];
      MyCont.Janr:= SG.Cells[3, i];
      MyCont.God:= SG.Cells[4, i];
      //записываем их:
      Write(f, MyCont);
    end;
  finally
    CloseFile(f);
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
var
  MyCont: Knigi; //для очередной записи
  f: file of Knigi; //файл данных
  i: integer; //счетчик цикла
begin
  //сначала получим адрес программы:
  adres:= ExtractFilePath(ParamStr(0));
  //настроим сетку:
  SG.Cells[0, 0]:= 'Код книги';
  SG.Cells[1, 0]:= 'Название';
  SG.Cells[2, 0]:= 'Автор';
  SG.Cells[3, 0]:= 'Жанр';
  SG.Cells[4, 0]:= 'Год издания';
  SG.ColWidths[0]:= 150;
  SG.ColWidths[1]:= 150;
  SG.ColWidths[2]:= 150;
  SG.ColWidths[3]:= 150;
  SG.ColWidths[4]:= 150;
  //если файла данных нет, просто выходим:
  if not FileExists(adres + 'telephones.dat') then exit;
  //иначе файл есть, открываем его для чтения и
  //считываем данные в сетку:
  try
    AssignFile(f, adres + 'knigi.dat');
    Reset(f);
    //теперь цикл - от первой до последней записи сетки:
    while not Eof(f) do begin
      //считываем новую запись:
      Read(f, MyCont);
      //добавляем в сетку новую строку, и заполняем её:
      SG.RowCount:= SG.RowCount + 1;
      SG.Cells[0, SG.RowCount-1]:= MyCont.Kod;
      SG.Cells[1, SG.RowCount-1]:= MyCont.Name;
      SG.Cells[2, SG.RowCount-1]:= MyCont.Avtor;
      SG.Cells[3, SG.RowCount-1]:= MyCont.Janr;
      SG.Cells[4, SG.RowCount-1]:= MyCont.God;
    end;
  finally
    CloseFile(f);
  end;
end;

end.

