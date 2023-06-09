
#Область ПрограммныйИнтерфейс

// Записывает в регистр сведений информацию осоответствии объектов
// Параметры:
//  ОбъектERP - СправочникСсылка
//  ОбъектCreatio - Строка
//
Процедура УстановитьСоответствие(ОбъектERP, ОбъектCreatio) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.бг_creatio_СоответствиеОбъектов.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.ОбъектERP = ОбъектERP;
	МенеджерЗаписи.ОбъектCreatio = ОбъектCreatio;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Возвращает признак того, что объект загружен из Creatio
// Параметры:
//  ОбъектERP - СправочникСсылка
//
// Тип возвращаемого значения - Булево
//
Функция ОбъектЗагруженИзCreatio(ОбъектERP) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектERP", ОбъектERP);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бг_creatio_СоответствиеОбъектов.ОбъектCreatio КАК ОбъектCreatio
	|ИЗ
	|	РегистрСведений.бг_creatio_СоответствиеОбъектов КАК бг_creatio_СоответствиеОбъектов
	|ГДЕ
	|	бг_creatio_СоответствиеОбъектов.ОбъектERP = &ОбъектERP";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Возвращает признак того, что объект загружен из Creatio
// Параметры:
//  ИдентификаторCreatio - Строка
//
// Тип возвращаемого значения - СправочникСсылка
//
Функция ОбъектПоИдентификаторуCreatio(ИдентификаторCreatio) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторCreatio", ИдентификаторCreatio);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	бг_creatio_СоответствиеОбъектов.ОбъектERP КАК Ссылка
	|ИЗ
	|	РегистрСведений.бг_creatio_СоответствиеОбъектов КАК бг_creatio_СоответствиеОбъектов
	|ГДЕ
	|	бг_creatio_СоответствиеОбъектов.ОбъектCreatio = &ИдентификаторCreatio";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

#КонецОбласти