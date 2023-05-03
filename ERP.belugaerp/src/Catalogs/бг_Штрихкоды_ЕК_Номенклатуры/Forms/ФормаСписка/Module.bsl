#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор")
		И Параметры.Отбор.Свойство("Номенклатура") Тогда
		СоздатьКнопкиСозданияШтрихкодов(Параметры.Отбор.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура СоздатьШтрихкод(Команда)
	
	Владелец = СоотетствиеИменКнопок.Получить(Команда.Имя);
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		ОткрытьФорму("Справочник.бг_Штрихкоды_ЕК_Номенклатуры.ФормаОбъекта",
			Новый Структура("Владелец", Владелец),
			,
			Истина);
	КонецЕсли;
		
КонецПроцедуры   

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьКнопкиСозданияШтрихкодов(Номенклатура) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕдиницаКоробка.Ссылка КАК ЕдиницаИзмеренияКоробка,
	|	ЕСТЬNULL(УпаковкаПаллета.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК ЕдиницаИзмеренияПаллета
	|ПОМЕСТИТЬ втКоробки
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК ЕдиницаКоробка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкаПаллета
	|		ПО ЕдиницаКоробка.Ссылка = УпаковкаПаллета.Родитель
	|			И (УпаковкаПаллета.ЕдиницаИзмерения.бг_ТипЕдиницыИзмерения = &ТипПаллета)
	|ГДЕ
	|	ЕдиницаКоробка.Владелец = &ИсточникКопирования
	|	И ЕдиницаКоробка.ЕдиницаИзмерения.бг_ТипЕдиницыИзмерения = &ТипКоробка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втКоробки.ЕдиницаИзмеренияКоробка КАК ЕдиницаИзмеренияКоробка,
	|	втКоробки.ЕдиницаИзмеренияПаллета КАК ЕдиницаИзмеренияПаллета,
	|	втКоробки.ЕдиницаИзмеренияКоробка.Наименование КАК КоробкаНаименование,
	|	втКоробки.ЕдиницаИзмеренияПаллета.Наименование КАК ПаллетаНаименование
	|ИЗ
	|	втКоробки КАК втКоробки";
	
	Запрос.УстановитьПараметр("ИсточникКопирования", Номенклатура);
	Запрос.УстановитьПараметр("ТипКоробка", Перечисления.бг_ТипыЕдиницИзмерения.Коробка);
	Запрос.УстановитьПараметр("ТипПаллета", Перечисления.бг_ТипыЕдиницИзмерения.Паллета);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаУпаковки = РезультатЗапроса.Выгрузить(); 
	
	СоответствиеИмен = Новый Соответствие;
	
	Если ТаблицаУпаковки.Количество() = 1 Тогда  
		
		бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
			ЭтотОбъект,
			"СоздатьШтрихкод",
			Элементы.ФормаКоманднаяПанель,
			НСтр("ru= 'Создать штрихкод'"),
			"СоздатьШтрихкод",
			"СоздатьШтрихкод"); 
		СоответствиеИмен.Вставить("СоздатьШтрихкод", ТаблицаУпаковки[0].ЕдиницаИзмеренияКоробка);
		
	ИначеЕсли ТаблицаУпаковки.Количество() > 1 Тогда
		
		ГруппаКоманд = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьГруппуНаФорму(
			ЭтотОбъект,
			"СоздатьШтрихкод",
			Элементы.ФормаКоманднаяПанель,
			ВидГруппыФормы.Подменю);
			
		ГруппаКоманд.Заголовок = НСтр("ru= 'Создать штрихкод'");
			
		Итератор = 1;
		Для каждого СтрокаТЧ Из ТаблицаУпаковки Цикл
			
			Если ЗначениеЗаполнено(СтрокаТЧ.ЕдиницаИзмеренияПаллета) Тогда
				ПредставлениеКоманды = СтрШаблон(
					НСтр("ru='%1 / %2'"), 
					СтрокаТЧ.КоробкаНаименование, 
					СтрокаТЧ.ПаллетаНаименование);
			Иначе
				ПредставлениеКоманды = СтрШаблон(
					НСтр("ru='%1'"), 
					СтрокаТЧ.КоробкаНаименование); 
			КонецЕсли; 
			
			ИмяКоманды = СтрШаблон("СоздатьШтрихкод%1", Итератор);
			
			бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
				ЭтотОбъект,
				ИмяКоманды,
				ГруппаКоманд,
				ПредставлениеКоманды,
				ИмяКоманды,
				"СоздатьШтрихкод");
				
			СоответствиеИмен.Вставить(ИмяКоманды, СтрокаТЧ.ЕдиницаИзмеренияКоробка); 
			Итератор = Итератор + 1;
			
		КонецЦикла;
	КонецЕсли;  
	
	СоотетствиеИменКнопок = Новый ФиксированноеСоответствие(СоответствиеИмен);
	
КонецПроцедуры

#КонецОбласти
