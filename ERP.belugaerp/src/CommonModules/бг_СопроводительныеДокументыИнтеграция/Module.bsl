
#Область ПрограммныйИнтерфейс

// Регистрация исходящего сообщения.
// Параметры:
//	СправочникОбъект - СправочникОбъект.бг_СопроводительныеДокументы - записываемый объект.
//
Процедура ВыгрузитьСвязанныеОбъекты(СправочникОбъект) Экспорт
	
	ВидПередЗаписью = Неопределено;
	ПутьКФайлуПередЗаписью = Неопределено;
	
	СправочникОбъект.ДополнительныеСвойства.Свойство("ВидПередЗаписью", ВидПередЗаписью);
	СправочникОбъект.ДополнительныеСвойства.Свойство("ПутьКФайлуПередЗаписью", ПутьКФайлуПередЗаписью);
	
	ВидыДокументов = бг_КонстантыПовтИсп.ЗначенияКонстант(
		"ВидДокументаУдостоверенияКачества, ВидДокументаДекларацияСоответствия");
	
	Если (ТипЗнч(СправочникОбъект.Владелец) = Тип("СправочникСсылка.СерииНоменклатуры")
			И (СправочникОбъект.Вид = ВидыДокументов.ВидДокументаУдостоверенияКачества
				Или ВидПередЗаписью = ВидыДокументов.ВидДокументаУдостоверенияКачества)
		Или ТипЗнч(СправочникОбъект.Владелец) = Тип("СправочникСсылка.СертификатыНоменклатуры")
				И (СправочникОбъект.Вид = ВидыДокументов.ВидДокументаДекларацияСоответствия
					Или ВидПередЗаписью = ВидыДокументов.ВидДокументаДекларацияСоответствия))
		И (Не СправочникОбъект.Вид = ВидПередЗаписью
			Или Не СправочникОбъект.ПутьКФайлу = ПутьКФайлуПередЗаписью) Тогда
		бг_ОбщегоНазначенияСервер.ЗарегистрироватьИсходящееСообщениеПриЗаписи(СправочникОбъект.Владелец);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти