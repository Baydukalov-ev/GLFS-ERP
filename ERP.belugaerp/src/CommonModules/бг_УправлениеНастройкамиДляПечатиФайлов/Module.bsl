
#Область ПрограммныйИнтерфейс

Функция ПроверитьУстановитьПрограммуПечати() Экспорт
	
	Параметры = Новый Структура;
	
	WSShell = Новый COMОбъект("WScript.Shell");
	Параметры.Вставить("Каталог", WSShell.ExpandEnvironmentStrings("%APPDATA%") + "\pdfprint\");
	Параметры.Вставить("Название", "pdfprint.exe");
	Параметры.Вставить("ПолныйПуть", Параметры.Каталог + Параметры.Название);
	Параметры.Вставить("ОшибкаПодключения", Ложь);
	
	ПутьКАрхиву = "";
	Попытка
		
		ФайлКаталогИнструмента = Новый Файл(Параметры.Каталог);
		
		Если Не ФайлКаталогИнструмента.Существует() Тогда
			
			ДвоичныеДанные = бг_ПечатьВнешнихФайловСерверПовтИсп.ДвоичныеДанныеПрограммыПечати();
			ПутьКАрхиву = ПолучитьИмяВременногоФайла();
			ДвоичныеДанные.Записать(ПутьКАрхиву);
			
			ЧтениеФайлаАрхива = Новый ЧтениеZipФайла(ПутьКАрхиву);
			ЧтениеФайлаАрхива.ИзвлечьВсе(Параметры.Каталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
			
		КонецЕсли;
		
	Исключение
		
		Параметры.ОшибкаПодключения = Истина;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОписаниеОшибки());
		
	КонецПопытки;
	
	Если Не ПустаяСтрока(ПутьКАрхиву) Тогда
		Попытка
			УдалитьФайлы(ПутьКАрхиву);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

Функция НастройкиПринтера(ПараметрыПрограммыПечати) Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("ОдносторонняяПечать", ПараметрыПрограммыПечати.Каталог +"OneSidePrint.dat");
	Настройки.Вставить("ДвусторонняяПечать", ПараметрыПрограммыПечати.Каталог +"DoubleSidePrint.dat");
	
	Возврат Настройки;
	
КонецФункции

Функция НастройкаВыполнена(ПутьКНастройке) Экспорт
	
	Файл = Новый Файл(ПутьКНастройке);
	Возврат Файл.Существует();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПринтерПоУмолчанию() Экспорт
    
    Скрипт = Новый ComObject("MSScriptControl.ScriptControl");
    Скрипт.Language = "vbscript";                 
    Скрипт.AddCode("
         |Function GetDefaultPrinter()
         |GetDefaultPrinter=vbNullString
         |Set objWMIService=GetObject(""winmgmts:"" _
         |& ""{impersonationLevel=impersonate}!\\.\root\cimv2"")
         |Set colInstalledPrinters=objWMIService.ExecQuery _
         |(""Select * from Win32_Printer"")
         |For Each objPrinter in colInstalledPrinters
         |If objPrinter.Attributes and 4 Then
         |GetDefaultPrinter=objPrinter.Name
         |Exit For
         |End If
         |Next
         |End Function");
         
    Возврат СокрЛП(Скрипт.run("GetDefaultPrinter"));
    
КонецФункции

#КонецОбласти
