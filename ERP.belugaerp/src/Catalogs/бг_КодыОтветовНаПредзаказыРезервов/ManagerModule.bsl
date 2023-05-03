#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает ссылку на элемент справочника с кодом ответа на предзаказ резервов клиента.
//
//  Параметры:
//   Код - Строка - Код ответа строкой, для которого надо получить ссылку на элемент справочника
//
//  Возвращаемое значение:
//   КодОтвета - СправочникСсылка.бг_КодыОтветовНаПредзаказыРезервов - Код ответа на предзаказ резервов.
//    
Функция КодОтветаНаПредзаказРезервов(Код) Экспорт
	
	КодОтвета = Неопределено;
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Возврат КодОтвета;
	КонецЕсли;
	
	КодОтвета = НайтиСоздатьКодОтветаНаПредзаказРезервов(Код);
	
	Возврат КодОтвета;
	
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает созданный или найденный Код ответа на предзаказ резервов клиента по строковому коду.
//
// Параметры:
//  Код - Строка - Код ответа строкой.
//
// Возвращаемое значение:
//   КодОтвета - СправочникСсылка.бг_КодыОтветовНаПредзаказыРезервов - Ссылка на созданный/найденный Код ответа.
//
Функция НайтиСоздатьКодОтветаНаПредзаказРезервов(Код)
	
	КодОтвета = Неопределено;
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Возврат КодОтвета;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код", Код);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бг_КодыОтветовНаПредзаказыРезервов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.бг_КодыОтветовНаПредзаказыРезервов КАК бг_КодыОтветовНаПредзаказыРезервов
	|ГДЕ
	|	НЕ бг_КодыОтветовНаПредзаказыРезервов.ПометкаУдаления
	|	И бг_КодыОтветовНаПредзаказыРезервов.Код = &Код";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		КодОтвета = Выборка.Ссылка;
	Иначе
		КодОтвета = СоздатьКодОтветаНаПредзаказРезервов(Код);	
	КонецЕсли;	
	
	Возврат КодОтвета;
	
КонецФункции	

Функция СоздатьКодОтветаНаПредзаказРезервов(Код)
	
	Описание = ОписаниеКодаОтветаНаПредзаказРезервов(Код);
	
	Если Описание = "" Тогда
		ВызватьИсключение СтрШаблон(
							НСтр("ru='Попытка обращения к неизвестному коду ответа на предзаказ резервов клиента ""%1""'"),
							Код);
	КонецЕсли;
	
	НетВнешнейТранзакции = Не ТранзакцияАктивна();
	
	Если НетВнешнейТранзакции Тогда 
		НачатьТранзакцию();
	КонецЕсли;
	
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		БлокировкаСправочника = Блокировка.Добавить("Справочник.бг_КодыОтветовНаПредзаказыРезервов");
		БлокировкаСправочника.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();

		КодОтветаОбъект = Справочники.бг_КодыОтветовНаПредзаказыРезервов.СоздатьЭлемент();
		КодОтветаОбъект.Код = Код;
		КодОтветаОбъект.Описание = Описание; 
		КодОтветаОбъект.Записать();
		
		КодОтвета = КодОтветаОбъект.Ссылка;
		
		Если НетВнешнейТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;

	Исключение
		
		КодОтвета = Неопределено;
		
		ТекстОшибки = СтрШаблон(
						НСтр("ru='Не удалось создать код ответа на предзаказ резервов клиента ""%1""
							|По причине: %2'"), Код, ОписаниеОшибки());
						
		Если НетВнешнейТранзакции Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
			
		ВызватьИсключение ТекстОшибки;
			
	КонецПопытки;
	
	Возврат КодОтвета;
	
КонецФункции	

Функция ОписаниеКодаОтветаНаПредзаказРезервов(Код)

	Если Код = "200" Тогда
		Описание = 
			НСтр("ru = 'Предзаказ сформирован. Выполнено полное резервирование.'"); 
	ИначеЕсли Код = "201" Тогда	
		Описание = 
			НСтр("ru = 'Предзаказ сформирован. Выполнено частичное резервирование. По некоторым позициям недостаточно товара.'");
	ИначеЕсли Код = "202" Тогда	
		Описание = 
			НСтр("ru = 'Отменено резервирование по предзаказу.'");
	ИначеЕсли Код = "203" Тогда	
		Описание = 
			НСтр("ru = 'Для заказа нет доступных остатков. Резервирование не выполнено.'");
	ИначеЕсли Код = "400" Тогда	
		Описание = 
			НСтр("ru = 'Ошибка чтения xml.'");
	ИначеЕсли Код = "403" Тогда	
		Описание = 
			НСтр("ru = 'Нельзя изменить резерв или отменить заказ. Предзаказ включен в консолидированный заказ на поставку.'");
	ИначеЕсли Код = "404" Тогда	
		Описание = 
			НСтр("ru = 'Заказ по номеру %Номер заказа% не найден в 1С ERP.'");
	ИначеЕсли Код = "500" Тогда	
		Описание = 
			НСтр("ru = '%Внутреннее описание ошибки 1С ERP%.'");
	Иначе
		Описание = "";
	КонецЕсли;	
		
	Возврат Описание;	
		
КонецФункции

#КонецОбласти

#КонецЕсли
