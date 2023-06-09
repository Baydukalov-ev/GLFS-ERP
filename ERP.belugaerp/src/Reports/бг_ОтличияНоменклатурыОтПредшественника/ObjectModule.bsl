Функция СравниваемыеРеквизиты()
	
	РеквизитыИсключаемыеИзСравнения = Новый Массив;
	РеквизитыИсключаемыеИзСравнения.Добавить("Ссылка");
	РеквизитыИсключаемыеИзСравнения.Добавить("Версия");
	
	Для Каждого Реквизит Из Метаданные.Справочники.Номенклатура.Реквизиты Цикл
		
		Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
			РеквизитыИсключаемыеИзСравнения.Добавить(Реквизит.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	СравниваемыеРеквизиты = Новый СписокЗначений;
	
	Для Каждого Реквизит Из Метаданные.Справочники.Номенклатура.СтандартныеРеквизиты Цикл
		
		Если РеквизитыИсключаемыеИзСравнения.Найти(Реквизит.Имя) = Неопределено Тогда
			
			Синоним = Реквизит.Синоним;
			
			Если Не ЗначениеЗаполнено(Синоним) Тогда
				
				Если Реквизит.Имя = "ИмяПредопределенныхДанных" Тогда
					Синоним = "Имя предопределенных данных";
				ИначеЕсли Реквизит.Имя = "Предопределенный" Тогда
					Синоним = "Предопределенный";
				ИначеЕсли Реквизит.Имя = "ПометкаУдаления" Тогда
					Синоним = "Пометка удаления";
				ИначеЕсли Реквизит.Имя = "ЭтоГруппа" Тогда
					Синоним = "Это группа";
				ИначеЕсли Реквизит.Имя = "Родитель" Тогда
					Синоним = "Родитель";
				ИначеЕсли Реквизит.Имя = "Наименование" Тогда
					Синоним = "Наименование";
				ИначеЕсли Реквизит.Имя = "Код" Тогда
					Синоним = "Код";
				ИначеЕсли Реквизит.Имя = "Ссылка" Тогда
					Синоним = "Ссылка";
				ИначеЕсли Реквизит.Имя = "Владелец" Тогда
					Синоним = "Владелец";
				КонецЕсли;
				
			КонецЕсли;
			
			СравниваемыеРеквизиты.Добавить(Реквизит.Имя, Синоним);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Реквизит Из Метаданные.Справочники.Номенклатура.Реквизиты Цикл
		
		Если РеквизитыИсключаемыеИзСравнения.Найти(Реквизит.Имя) = Неопределено Тогда
			СравниваемыеРеквизиты.Добавить(Реквизит.Имя, Реквизит.Синоним);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СравниваемыеРеквизиты;
	
КонецФункции

СравниваемыеРеквизиты = СравниваемыеРеквизиты();

ЧастиТекстаЗапроса = Новый Массив;

ЧастиТекстаЗапроса.Добавить("ВЫБРАТЬ");

Для ПорядковыйНомерРеквизита = 0 По СравниваемыеРеквизиты.Количество() - 1 Цикл
	
	ЧастьТекстаЗапроса = СтрШаблон(
		"	Номенклатура.%1 КАК Номенклатура%1,
		|	Номенклатура.бг_Предшественник.%1 КАК Предшественник%1,",
		СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Значение);
	
	ЧастиТекстаЗапроса.Добавить(ЧастьТекстаЗапроса);
	
КонецЦикла;

ЧастиТекстаЗапроса.Добавить(
	"	Номенклатура.Ссылка КАК Номенклатура,
	|	Номенклатура.бг_Предшественник КАК Предшественник
	|ПОМЕСТИТЬ ВТНоменклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.бг_Предшественник <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	NULL КАК Номенклатура,
	|	NULL КАК Предшественник,
	|	NULL КАК ИмяРеквизита,
	|	NULL КАК СинонимРеквизита,
	|	NULL КАК ЗначениеНоменклатуры,
	|	NULL КАК ЗначениеПредшественника,
	|	NULL КАК Отличается
	|ИЗ
	|	ВТНоменклатура КАК ВТНоменклатура
	|ГДЕ
	|	ЛОЖЬ");

Для ПорядковыйНомерРеквизита = 0 По СравниваемыеРеквизиты.Количество() - 1 Цикл
	
	ЧастьТекстаЗапроса = СтрШаблон(
		"
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТНоменклатура.Номенклатура,
		|	ВТНоменклатура.Предшественник,
		|	""%1"",
		|	""%2"",",
		СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Значение,
		СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Представление);
	
	ЧастиТекстаЗапроса.Добавить(ЧастьТекстаЗапроса);
	
	Если Метаданные.Справочники.Номенклатура.Реквизиты.Найти(СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Значение) <> Неопределено
		И Метаданные.Справочники.Номенклатура.Реквизиты[СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Значение].Тип.СодержитТип(Тип("Строка"))
		И Метаданные.Справочники.Номенклатура.Реквизиты[СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Значение].Тип.КвалификаторыСтроки.Длина = 0 Тогда
		ЧастьТекстаЗапроса = СтрШаблон(
			"	ВЫРАЗИТЬ(ВТНоменклатура.Номенклатура%1 КАК СТРОКА(1024)),
			|	ВЫРАЗИТЬ(ВТНоменклатура.Предшественник%1 КАК СТРОКА(1024)),
			|	ВЫРАЗИТЬ(ВТНоменклатура.Номенклатура%1 КАК СТРОКА(1024)) <> ВЫРАЗИТЬ(ВТНоменклатура.Предшественник%1 КАК СТРОКА(1024))",
			СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Значение);
	Иначе
		ЧастьТекстаЗапроса = СтрШаблон(
			"	ВТНоменклатура.Номенклатура%1,
			|	ВТНоменклатура.Предшественник%1,
			|	ВТНоменклатура.Номенклатура%1 <> ВТНоменклатура.Предшественник%1",
			СравниваемыеРеквизиты[ПорядковыйНомерРеквизита].Значение);
	КонецЕсли;
	
	ЧастиТекстаЗапроса.Добавить(ЧастьТекстаЗапроса);
	
	ЧастиТекстаЗапроса.Добавить(
		"ИЗ
		|	ВТНоменклатура КАК ВТНоменклатура");
	
КонецЦикла;

СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = СтрСоединить(ЧастиТекстаЗапроса, Символы.ПС);
