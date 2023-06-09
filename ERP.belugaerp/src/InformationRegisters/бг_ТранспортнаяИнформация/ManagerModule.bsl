#Область ПрограммныйИнтерфейс

// Возвращает транспортную информацию по переданному документу.
//
// Параметры:
//  Объект  - Произвольный - объект, по которому хранится информация в регистре бг_ТранспортнаяИнформация.
//		Примечание: предполагается, что объектом будет являться ЗаказКлиента или РТУ.
//
// Возвращаемое значение:
//   Структура
//
Функция ТранспортнаяИнформация(Объект) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	бг_ТранспортнаяИнформация.Объект КАК Объект,
	|	бг_ТранспортнаяИнформация.Объект.Номер КАК ОбъектНомер,
	|	бг_ТранспортнаяИнформация.Объект.Дата КАК ОбъектДата,
	|	бг_ТранспортнаяИнформация.ТранспортноеСредство КАК ТранспортноеСредство,
	|	бг_ТранспортнаяИнформация.ТранспортноеСредство.Представление КАК ТранспортноеСредствоПредставление,
	|	бг_ТранспортнаяИнформация.Представление КАК Представление,
	|	бг_ТранспортнаяИнформация.ПлановаяДатаДоставкиС КАК ПлановаяДатаДоставкиС,
	|	бг_ТранспортнаяИнформация.ПлановаяДатаДоставкиПо КАК ПлановаяДатаДоставкиПо,
	|	бг_ТранспортнаяИнформация.Водитель КАК Водитель,
	|	бг_ТранспортнаяИнформация.Перевозчик КАК Перевозчик,
	|	бг_ТранспортнаяИнформация.ЗначениеПоУмолчанию КАК ЗначениеПоУмолчанию,
	|	бг_ТранспортнаяИнформация.Комментарий КАК Комментарий,
	|	бг_ТранспортнаяИнформация.Заказчик КАК Заказчик,
	|	бг_ТранспортнаяИнформация.ВидПеревозки КАК ВидПеревозки,
	|	бг_ТранспортнаяИнформация.ДоверенностьНомер КАК ДоверенностьНомер,
	|	бг_ТранспортнаяИнформация.ДоверенностьДата КАК ДоверенностьДата,
	|	бг_ТранспортнаяИнформация.ДоверенностьЧерез КАК ДоверенностьЧерез,
	|	бг_ТранспортнаяИнформация.НомерЗаказа КАК НомерЗаказа,
	|	бг_ТранспортнаяИнформация.НомераПломб КАК НомераПломб,
	|	бг_ТранспортнаяИнформация.ХранилищеДополнительныхСведений КАК ХранилищеДополнительныхСведений,
	|	бг_ТранспортнаяИнформация.ХранилищеСведенийТНиСВ КАК ХранилищеСведенийТНиСВ,
	|	бг_ТранспортнаяИнформация.ДатаТН КАК ДатаТН,
	|	бг_ТранспортнаяИнформация.НомерТН КАК НомерТН,
	|	бг_ТранспортнаяИнформация.Прицеп КАК Прицеп,
	|	бг_ТранспортнаяИнформация.ПорядковыйНомерТС КАК ПорядковыйНомерТС,
	|	бг_ТранспортнаяИнформация.ТипВладенияТС КАК ТипВладенияТС,
	|	бг_ТранспортнаяИнформация.ПунктНазначения КАК ПунктНазначения,
	|	бг_ТранспортнаяИнформация.МыГрузимТовар КАК МыГрузимТовар,
	|	бг_ТранспортнаяИнформация.ДоговорНаВладение КАК ДоговорНаВладение,
	|	бг_ТранспортнаяИнформация.ДоговорНаПеревозку КАК ДоговорНаПеревозку,
	|	бг_ТранспортнаяИнформация.ДоговорСубподряда КАК ДоговорСубподряда,
	|	бг_ТранспортнаяИнформация.ОрганизаторПеревозки КАК ОрганизаторПеревозки
	|ИЗ
	|	РегистрСведений.бг_ТранспортнаяИнформация КАК бг_ТранспортнаяИнформация
	|ГДЕ
	|	бг_ТранспортнаяИнформация.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	
	ТаблицаТранспортнойИнформации = Запрос.Выполнить().Выгрузить();
	
	// Предполагаем, что по документу может быть только одна запись с одним ТС до выяснения обратного.
	Если ТаблицаТранспортнойИнформации.Количество() > 0 Тогда
		Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаТранспортнойИнформации)[0];
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает транспортную информацию по переданному массиву документов.
//
// Параметры:
//  Объект  - Массив - Произвольный - массив объектов, по которым хранится информация в регистре бг_ТранспортнаяИнформация.
//
// Возвращаемое значение:
//   ТаблицаЗначений - транспортная информация по объектам
//
Функция ТранспортнаяИнформацияОбъектов(Объекты) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ 
	|	бг_ТранспортнаяИнформация.Объект КАК Объект,
	|	бг_ТранспортнаяИнформация.Объект.Номер КАК ОбъектНомер,
	|	бг_ТранспортнаяИнформация.Объект.Дата КАК ОбъектДата,
	|	бг_ТранспортнаяИнформация.ТранспортноеСредство КАК ТранспортноеСредство,
	|	бг_ТранспортнаяИнформация.ТранспортноеСредство.Представление КАК ТранспортноеСредствоПредставление,
	|	бг_ТранспортнаяИнформация.Представление КАК Представление,
	|	бг_ТранспортнаяИнформация.ПлановаяДатаДоставкиС КАК ПлановаяДатаДоставкиС,
	|	бг_ТранспортнаяИнформация.ПлановаяДатаДоставкиПо КАК ПлановаяДатаДоставкиПо,
	|	бг_ТранспортнаяИнформация.Водитель КАК Водитель,
	|	бг_ТранспортнаяИнформация.Перевозчик КАК Перевозчик,
	|	бг_ТранспортнаяИнформация.ЗначениеПоУмолчанию КАК ЗначениеПоУмолчанию,
	|	бг_ТранспортнаяИнформация.Комментарий КАК Комментарий,
	|	бг_ТранспортнаяИнформация.Заказчик КАК Заказчик,
	|	бг_ТранспортнаяИнформация.ВидПеревозки КАК ВидПеревозки,
	|	бг_ТранспортнаяИнформация.ДоверенностьНомер КАК ДоверенностьНомер,
	|	бг_ТранспортнаяИнформация.ДоверенностьДата КАК ДоверенностьДата,
	|	бг_ТранспортнаяИнформация.ДоверенностьЧерез КАК ДоверенностьЧерез,
	|	бг_ТранспортнаяИнформация.НомерЗаказа КАК НомерЗаказа,
	|	бг_ТранспортнаяИнформация.НомераПломб КАК НомераПломб,
	|	бг_ТранспортнаяИнформация.ХранилищеДополнительныхСведений КАК ХранилищеДополнительныхСведений,
	|	бг_ТранспортнаяИнформация.ХранилищеСведенийТНиСВ КАК ХранилищеСведенийТНиСВ,
	|	бг_ТранспортнаяИнформация.ДатаТН КАК ДатаТН,
	|	бг_ТранспортнаяИнформация.НомерТН КАК НомерТН,
	|	бг_ТранспортнаяИнформация.Прицеп КАК Прицеп,
	|	бг_ТранспортнаяИнформация.ПорядковыйНомерТС КАК ПорядковыйНомерТС,
	|	бг_ТранспортнаяИнформация.ТипВладенияТС КАК ТипВладенияТС,
	|	бг_ТранспортнаяИнформация.ПунктНазначения КАК ПунктНазначения,
	|	бг_ТранспортнаяИнформация.МыГрузимТовар КАК МыГрузимТовар,
	|	бг_ТранспортнаяИнформация.ДоговорНаВладение КАК ДоговорНаВладение,
	|	бг_ТранспортнаяИнформация.ОрганизаторПеревозки КАК ОрганизаторПеревозки
	|ИЗ
	|	РегистрСведений.бг_ТранспортнаяИнформация КАК бг_ТранспортнаяИнформация
	|ГДЕ
	|	бг_ТранспортнаяИнформация.Объект В(&Объекты)";
	
	Запрос.УстановитьПараметр("Объекты", Объекты);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру параметров для первоначального заполнения записи транспортной информации
// 
// Возвращаемое значение:
//   Структура - структура для первоначального заполнения записи транспортной информации, 
//   			ключи структуры равны значениям ресурсов регистра ТИ.
Функция ПараметрыЗаполненияТранспортнойИнформации() Экспорт             
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Структура;
	Для каждого Ресурс Из Метаданные.РегистрыСведений.бг_ТранспортнаяИнформация.Ресурсы Цикл
		Результат.Вставить(Ресурс.Имя);
	КонецЦикла;                          
	Возврат Результат;
КонецФункции

// Записывает в регистр сведений, транспортную информацию объекта по заказу клиента
// Примечание: предполагается, что объектом будет являться РТиУ.
// 
// Параметры:
//   Объект  - Ссылка - объект,
//	 по которому необходимо внести информацию в регистр бг_ТранспортнаяИнформация.
//
Процедура ДобавитьОбъект(Объект, ЗаказКлиента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущаяТранспортнаяИнформация = ТранспортнаяИнформация(Объект);
	
	Если ЗначениеЗаполнено(ТекущаяТранспортнаяИнформация) Тогда
		Возврат;
	КонецЕсли;
	
	ТранспортнаяИнформацияПоЗаказуКлиента = ТранспортнаяИнформация(ЗаказКлиента);
	
	Если ЗначениеЗаполнено(ТранспортнаяИнформацияПоЗаказуКлиента) Тогда
		
		НоваяЗапись = РегистрыСведений.бг_ТранспортнаяИнформация.СоздатьМенеджерЗаписи(); 	
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ТранспортнаяИнформацияПоЗаказуКлиента);		
		НоваяЗапись.Объект = Объект;		
		НоваяЗапись.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти