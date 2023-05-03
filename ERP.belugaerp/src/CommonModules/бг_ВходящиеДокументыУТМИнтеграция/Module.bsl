
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства, СтандартнаяОбработка) Экспорт
	
	ЗагружаемыйОбъект.ИдентификаторФСРАР = СтруктураОбъекта.ТранспортныйМодуль.ИдентификаторФСРАР;
	
	ЗагружаемыйОбъект.ТранспортныйМодуль = СтруктураОбъекта.ТранспортныйМодуль.Идентификатор;
	СтруктураОбъекта.ТранспортныйМодуль = ЗагружаемыйОбъект.ТранспортныйМодуль;
	
	Если СтруктураОбъекта.ДокументЕГАИС = Неопределено Тогда
		ЗагружаемыйОбъект.ДокументЕГАИС = "";
	Иначе
		ЗагружаемыйОбъект.ДокументЕГАИС = СтруктураОбъекта.ДокументЕГАИС.Идентификатор;
	КонецЕсли;
	
	СтруктураОбъекта.ДокументЕГАИС = ЗагружаемыйОбъект.ДокументЕГАИС;
	
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(ПолучитьСтрокуИзДвоичныхДанных(СтруктураОбъекта.ТекстОбъектаXDTO));
	
	ЗагружаемыйОбъект.ТекстОбъектаXDTO = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
	СтруктураОбъекта.ТекстОбъектаXDTO = ЗагружаемыйОбъект.ТекстОбъектаXDTO;
	
	Если СтруктураОбъекта.Свойство("ВидДокумента") Тогда
		
		Если СтруктураОбъекта.ВидДокумента = Неопределено Тогда
			ЗагружаемыйОбъект.ВидДокумента = "";
		Иначе
			ЗагружаемыйОбъект.ВидДокумента = СтруктураОбъекта.ВидДокумента.Идентификатор;
		КонецЕсли;
		
		СтруктураОбъекта.ВидДокумента = ЗагружаемыйОбъект.ВидДокумента;
		
	КонецЕсли;
	
	Если СтруктураОбъекта.Свойство("ДокументОснование") Тогда
		
		Если СтруктураОбъекта.ДокументОснование = Неопределено Тогда
			ЗагружаемыйОбъект.ДокументОснование = "";
		Иначе
			ЗагружаемыйОбъект.ДокументОснование = СтруктураОбъекта.ДокументОснование.Идентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураОбъекта.Свойство("ТипДокумента", ЗагружаемыйОбъект.ТипДокумента);
	
	ЗагружаемыйОбъект.ОбработанВERP = Ложь;
	ЗагружаемыйОбъект.Статус = Перечисления.бг_СтатусыВходящихДокументовУТМ.Зарегистрирован;
	
КонецПроцедуры

Процедура ЗаполнитьМассивПроверяемыхРеквизитовБлокировки(МетаданныеОбъекта, МассивПроверяемыхРеквизитов, СтандартнаяОбработка) Экспорт
	
	МассивПроверяемыхРеквизитов.Добавить("ТранспортныйМодуль");
	МассивПроверяемыхРеквизитов.Добавить("АдресДокумента");
	МассивПроверяемыхРеквизитов.Добавить("Грузоотправитель");
	МассивПроверяемыхРеквизитов.Добавить("ДокументЕГАИС");
	МассивПроверяемыхРеквизитов.Добавить("ТекстОбъектаXDTO");
	МассивПроверяемыхРеквизитов.Добавить("ВидДокумента");
	МассивПроверяемыхРеквизитов.Добавить("Дата");
	МассивПроверяемыхРеквизитов.Добавить("Номер");
	МассивПроверяемыхРеквизитов.Добавить("ИдентификаторТТН");
	МассивПроверяемыхРеквизитов.Добавить("ДатаОперации");
	МассивПроверяемыхРеквизитов.Добавить("ДокументОснование");
	МассивПроверяемыхРеквизитов.Добавить("ТипДокумента");
	МассивПроверяемыхРеквизитов.Добавить("ОбработанВERP");
	
КонецПроцедуры

Функция СоздатьНаборЗаписейРегистра(Отбор, ПолноеИмя) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный; // Используем модуль из расширения БИТMDT
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	ОтборТранспортныйМодуль = Отбор.ТранспортныйМодуль;
	ОтборДокументЕГАИС = Отбор.ДокументЕГАИС;
	
	ОтборЗаписьТранспортныйМодуль = Новый Массив;
	ОтборЗаписьДокументЕГАИС = Новый Массив;
	КоличествоЗаписей = Отбор.Запись.Количество();
	
	Если КоличествоЗаписей = 0 Тогда
		Отбор.СодержитЗаписи = Ложь;
	КонецЕсли;
	
	Если Отбор.Свойство("Запись") Тогда
		
		Для НомерЗаписи = 0 По КоличествоЗаписей - 1 Цикл
			ОтборЗаписьТранспортныйМодуль.Добавить(Отбор.Запись[НомерЗаписи].ТранспортныйМодуль);
			ОтборЗаписьДокументЕГАИС.Добавить(Отбор.Запись[НомерЗаписи].ДокументЕГАИС);
		КонецЦикла;
		
	КонецЕсли;
	
	НаборЗаписей = адаптер_ОбработчикиСобытийСтандартный.СоздатьНаборЗаписейРегистра(Отбор, ПолноеИмя);
	
	Если ОтборТранспортныйМодуль = Неопределено
		Или ОтборТранспортныйМодуль.Идентификатор = Неопределено Тогда
		НаборЗаписей.Отбор.ТранспортныйМодуль.Значение = "";
	Иначе
		НаборЗаписей.Отбор.ТранспортныйМодуль.Значение = ОтборТранспортныйМодуль.Идентификатор;
	КонецЕсли;
	
	Если ОтборДокументЕГАИС = Неопределено
		Или ОтборДокументЕГАИС.Идентификатор = Неопределено Тогда
		НаборЗаписей.Отбор.ДокументЕГАИС.Значение = "";
	Иначе
		НаборЗаписей.Отбор.ДокументЕГАИС.Значение = ОтборДокументЕГАИС.Идентификатор;
	КонецЕсли;
	
	Отбор.ТранспортныйМодуль = ОтборТранспортныйМодуль;
	Отбор.ДокументЕГАИС = ОтборДокументЕГАИС;
	
	Для НомерЗаписи = 0 По КоличествоЗаписей - 1 Цикл
		Отбор.Запись[НомерЗаписи].ТранспортныйМодуль = ОтборЗаписьТранспортныйМодуль[НомерЗаписи];
		Отбор.Запись[НомерЗаписи].ДокументЕГАИС = ОтборЗаписьДокументЕГАИС[НомерЗаписи];
	КонецЦикла;
	
	Возврат НаборЗаписей;
	
КонецФункции

Процедура ЗаписатьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтандартнаяОбработка) Экспорт

	Если ЗагружаемыйОбъект.Количество() = 0
		Или Не ЗначениеЗаполнено(ЗагружаемыйОбъект[0].ТекстОбъектаXDTO) Тогда
		
		ЗагружаемыйОбъект.ДополнительныеСвойства.Вставить("СтандартнаяЗаписьНеТребуется", Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти