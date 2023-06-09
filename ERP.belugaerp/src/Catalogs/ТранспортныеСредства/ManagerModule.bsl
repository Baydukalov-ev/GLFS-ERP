#Область ПрограммныйИнтерфейс

// Проверяет и преобразовывает государственный номер к шаблону принятому на предприятии
// Заглавные английские буквы без пробелов и специальных знаков
// Параметры:
//	ГосНомер - Строка - государственный номер, который необходимо преобразовать
//  Отказ - Булево - будет взведен в Истина, если номер не соответствует шаблону и его не удалось преобразовать
//
Процедура бг_ПроверитьПреобразоватьГосНомерКШаблону(ГосНомер, Отказ = Ложь) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ДопустимыеСимволы = "АВЕКМНОРСТУХABEKMHOPCTYX1234567890 -_\|/QWERTYUIOPASDFGHJKLZXCVBNM";
	
	СимволыКирилицы = "АВЕКМНОРСТУХ";
	
	УдаляемыеСимволы = " -_\|/";
	
	СоответствиеКирилицы = бг_СоответствиеКирилицыЛатинице();
	
	НомерДляОбработки = ВРег(ГосНомер);  
	Результат = "";
	Для ИндексСимвола = 1 По СтрДлина(НомерДляОбработки) Цикл
		СимволНомера = Сред(НомерДляОбработки, ИндексСимвола, 1);
		Если СтрНайти(ДопустимыеСимволы, СимволНомера) > 0 Тогда
			Если СтрНайти(СимволыКирилицы, СимволНомера) Тогда
				Результат = Результат + СоответствиеКирилицы[СимволНомера];
			ИначеЕсли СтрНайти(УдаляемыеСимволы, СимволНомера) = 0 Тогда
				Результат = Результат + СимволНомера;
			Иначе 
				// Nop
			КонецЕсли;
		Иначе	
			ТекстОшибки = НСтр("ru='Недопустимый символ госномера <%1> (позиция: %2)'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, СимволНомера, ИндексСимвола);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
		КонецЕсли;
	КонецЦикла;
	Если Не Отказ Тогда
		ГосНомер = Результат;
	КонецЕсли;
КонецПроцедуры

&Вместо("ОбработкаПолученияДанныхВыбора")
Процедура бг_ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если Параметры.Свойство("СтрокаПоиска")
		И Не ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		
		бг_ПроверитьПреобразоватьГосНомерКШаблону(Параметры.СтрокаПоиска);
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 10
		|	ТранспортныеСредства.Ссылка КАК Ссылка,
		|	ТранспортныеСредства.Представление КАК Представление
		|ИЗ
		|	Справочник.ТранспортныеСредства КАК ТранспортныеСредства
		|ГДЕ
		|	ТранспортныеСредства.Код ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ДанныеВыбора = Новый СписокЗначений;
		Пока Выборка.Следующий() Цикл
			ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Представление);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&Вместо("ОбработкаПолученияФормы")
Процедура бг_ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) 
	Если ВидФормы = "ФормаОбъекта" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "бг_ФормаЭлемента";
	Иначе 
		ПродолжитьВызов(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция бг_СоответствиеКирилицыЛатинице()

	Результат = Новый Соответствие;
	Результат.Вставить("А", "A");
	Результат.Вставить("В", "B");
	Результат.Вставить("Е", "E");
	Результат.Вставить("К", "K");
	Результат.Вставить("М", "M");
	Результат.Вставить("Н", "H");
	Результат.Вставить("О", "O");
	Результат.Вставить("Р", "P");
	Результат.Вставить("С", "C");
	Результат.Вставить("Т", "T");
	Результат.Вставить("У", "Y");
	Результат.Вставить("Х", "X");
	
	Возврат Результат;

КонецФункции 

#КонецОбласти