
#Область ПрограммныйИнтерфейс

// Сохраняет пакет с полученными в формате XDTO, в данные в формате XML
// Параметры:
//  ОбъектXDTO - ОбъектXDTO - входящий пакет данных 
//  ПараметрыПакета - структура, ключи соответствуют именам полей регистра (см. СтруктураПараметровОбъекта())
// 
// Возвращаемое значение - Строка 36 - идентификатор сохраненного  пакета 
// 
Функция СохранитьПакет(ОбъектXDTO, ПараметрыОбъекта) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO);
	СтрокаXML = ЗаписьXML.Закрыть(); 
	
	НоваяЗапись = РегистрыСведений.бг_creatio_ПолученныеПакеты.СоздатьМенеджерЗаписи();
	НоваяЗапись.ИдентификаторПакета = Новый УникальныйИдентификатор;
	НоваяЗапись.ДатаПолучения = ТекущаяДатаСеанса();
	НоваяЗапись.ДанныеПакетаXML = СтрокаXML;
	ЗаполнитьЗначенияСвойств(НоваяЗапись, ПараметрыОбъекта);
	НоваяЗапись.Записать();
	
	Возврат НоваяЗапись.ИдентификаторПакета
	
КонецФункции

// Возвращает данные, сохраненные в формате XML, в формате XDTO объекта
// Параметры:
//  ИдентификаторПакета - Строка 36 - идентификатор сохраненного ранее пакета
//
// Возвращаемое значение:
//  ОбъектXDTO - Объект XDTO, восстановленный из сохраненной строки XML
//
Функция ВосстановитьПакет(ИдентификаторПакета) Экспорт
	
	ОбъектXDTO = Неопределено;
	
	ЗаписьРегистра = РегистрыСведений.бг_creatio_ПолученныеПакеты.СоздатьМенеджерЗаписи();
	ЗаписьРегистра.ИдентификаторПакета = ИдентификаторПакета;
	ЗаписьРегистра.Прочитать();
	
	Если ЗаписьРегистра.Выбран() Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ЗаписьРегистра.ДанныеПакетаXML);
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	КонецЕсли;
	
	Возврат ОбъектXDTO
	
КонецФункции

// Возвращает параметры для записи
// 
// Возвращаемое значение:
//  Структура - параметры для записи
//
Функция СтруктураПараметровОбъекта() Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВидОбъекта");
	СтруктураПараметров.Вставить("МетодВебСервиса");
	
	Возврат СтруктураПараметров
	
КонецФункции

#КонецОбласти




