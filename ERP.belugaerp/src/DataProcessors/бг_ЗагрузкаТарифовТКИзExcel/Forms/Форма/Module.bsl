#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АнализДанных(Команда)
	АнализИменКолонок();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайл(Команда)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);    
	ДиалогВыбораФайла.Заголовок = НСтр("ru='Прочитать табличный документ из файла'"); 
	ДиалогВыбораФайла.Фильтр    = "Все файлы Excel (*.xls, *.xlsx)|*.xls; *.xlsx";
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;

	Оповещение = Новый ОписаниеОповещения("ВыбратьФайлЗавершение", ЭтаФорма);
	ДиалогВыбораФайла.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() > 0 Тогда
		ИмяФайла = ВыбранныеФайлы[0];
		АдресРезультата = ПрочитатьФайлExcel(ИмяФайла);
		ЗаполнитьЗагруженныеДанныеНаСервере(АдресРезультата);
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаНастройки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьДанные(Команда)
	Если ЕстьВсеДанныеДляСопоставления() Тогда
		СопоставитьДанныеСервер();
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРезультатСопоставления;
	Иначе 
		ПоказатьПредупреждение( , НСтр("ru='Не все данные указаны'"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьТарифы(Команда)
	ОповещениеОтвет = Новый ОписаниеОповещения("ЗагрузитьТарифыЗавершение", ЭтотОбъект);
	РежимДиалога = Новый СписокЗначений;
	РежимДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Загрузить'"));
	РежимДиалога.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
	ПоказатьВопрос(ОповещениеОтвет, НСтр("ru='Загрузить тарифы?'"), РежимДиалога, , КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьТарифыЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗагрузитьТарифыНаСервере();
		ПоказатьПредупреждение(, НСтр("ru='Тарифы загружены'"));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СопоставленныеДанныеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СопоставленныеДанныеТипКузоваПриИзменении(Элемент)
	ЗаменитьЗначениеВТаблице("ТипКузоваСтрока", "ТипКузова");
КонецПроцедуры

&НаКлиенте
Процедура СопоставленныеДанныеПунктПогрузкиПриИзменении(Элемент)
	ЗаменитьЗначениеВТаблице("ПунктПогрузкиСтрока", "ПунктПогрузки");
КонецПроцедуры

&НаКлиенте
Процедура СопоставленныеДанныеЗонаДоставкиПриИзменении(Элемент)
	ЗаменитьЗначениеВТаблице("ЗонаДоставкиСтрока", "ЗонаДоставки");
КонецПроцедуры

&НаКлиенте
Процедура СопоставленныеДанныеКлассГрузоподъемностиПриИзменении(Элемент)
	ЗаменитьЗначениеВТаблице("КлассГрузоподъемностиСтрока", "КлассГрузоподъемности");
КонецПроцедуры

&НаКлиенте
Процедура СопоставленныеДанныеПеревозчикПриИзменении(Элемент)
	ЗаменитьЗначениеВТаблице("ПеревозчикСтрока", "Перевозчик");
КонецПроцедуры

&НаКлиенте
Процедура СопоставленныеДанныеПеревозчикКонтрагентПриИзменении(Элемент)
	ЗаменитьЗначениеВТаблице("ПеревозчикСтрока", "ПеревозчикКонтрагент");
КонецПроцедуры

#КонецОбласти                            

#Область СлужебныеПроцедурыИФункции     

&НаКлиенте
Процедура ЗаменитьЗначениеВТаблице(ИмяСтрока, ИмяСсылка)
	СтрокаИсточник = Элементы.СопоставленныеДанные.ТекущиеДанные;
	Если Не СтрокаИсточник = Неопределено Тогда
		ЗначениеПоиска = СтрокаИсточник[ИмяСтрока];
		ЗначениеЗамены = СтрокаИсточник[ИмяСсылка];
		СтрокиКЗамене = СопоставленныеДанные.НайтиСтроки(Новый Структура(ИмяСтрока, ЗначениеПоиска));
		Для каждого СтрокаЗамены Из СтрокиКЗамене Цикл
			СтрокаЗамены[ИмяСсылка] = ЗначениеЗамены;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#Область РаботаСExcel
	
&НаКлиенте
Функция ПрочитатьФайлExcel(ИмяФайла) Экспорт
	ТекстСостояние = НСтр("ru = 'Загрузка данных...'");
	Состояние(ТекстСостояние);
	ДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
	Возврат ПоместитьВоВременноеХранилище(ДанныеФайла, УникальныйИдентификатор);
КонецФункции

#КонецОбласти

&НаСервере
Процедура ОтметитьНезаполненныеЗначенияОчиститьЗагруженоОшибки() 
	Для каждого СтрокаСопоставления Из СопоставленныеДанные Цикл
		Если СтрокаСопоставления.Период = Дата(1, 1, 1)
			Или СтрокаСопоставления.ПеревозчикКонтрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка")
			Или СтрокаСопоставления.ПунктПогрузки = ПредопределенноеЗначение("Справочник.битПунктыНазначения.ПустаяСсылка")
			Или СтрокаСопоставления.ЗонаДоставки = ПредопределенноеЗначение("Справочник.бг_ЗоныДоставки.ПустаяСсылка")
			Или СтрокаСопоставления.КлассГрузоподъемности = ПредопределенноеЗначение("Справочник.бг_КлассыГрузоподъемностиТС.ПустаяСсылка")
			Или СтрокаСопоставления.ТипКузова = ПредопределенноеЗначение("Справочник.бг_ТипыКузова.ПустаяСсылка") Тогда
			СтрокаСопоставления.ЕстьНезаполненныеЗначения = Истина;
			СтрокаСопоставления.ТекстОшибки = НСтр("ru='Есть незаполненные значения'");
		Иначе 
			СтрокаСопоставления.ЕстьНезаполненныеЗначения = Ложь;
			СтрокаСопоставления.ТекстОшибки = ""
		КонецЕсли;
		СтрокаСопоставления.Загружено = Ложь;
		СтрокаСопоставления.ЕстьОшибки = Ложь;
	КонецЦикла
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТарифыНаСервере() 
	ОтметитьНезаполненныеЗначенияОчиститьЗагруженоОшибки();
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеИсточник", 
		СопоставленныеДанные.Выгрузить(, "Период, ДатаОкончания, ПунктПогрузки, ПеревозчикКонтрагент, ЗонаДоставки, КлассГрузоподъемности, ТипКузова, Стоимость"));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	Таблица.ПунктПогрузки КАК ПунктПогрузки,
	|	Таблица.ПеревозчикКонтрагент КАК Перевозчик,
	|	Таблица.ЗонаДоставки КАК ЗонаДоставки,
	|	Таблица.КлассГрузоподъемности КАК КлассГрузоподъемности,
	|	Таблица.ТипКузова КАК ТипКузова,
	|	Таблица.Стоимость КАК Стоимость,
	|	Таблица.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ втДанныеИсточник
	|ИЗ
	|	&ДанныеИсточник КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеИсточник.Период КАК Период,
	|	втДанныеИсточник.ПунктПогрузки КАК ПунктПогрузки,
	|	втДанныеИсточник.Перевозчик КАК Перевозчик,
	|	втДанныеИсточник.ЗонаДоставки КАК ЗонаДоставки,
	|	втДанныеИсточник.КлассГрузоподъемности КАК КлассГрузоподъемности,
	|	втДанныеИсточник.ТипКузова КАК ТипКузова,
	|	втДанныеИсточник.Стоимость КАК Стоимость,
	|	втДанныеИсточник.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ втДанные
	|ИЗ
	|	втДанныеИсточник КАК втДанныеИсточник
	|ГДЕ
	|	НЕ втДанныеИсточник.Период = ДАТАВРЕМЯ(1, 1, 1)
	|	И НЕ втДанныеИсточник.Перевозчик = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И НЕ втДанныеИсточник.ПунктПогрузки = ЗНАЧЕНИЕ(Справочник.битПунктыНазначения.ПустаяСсылка)
	|	И НЕ втДанныеИсточник.ЗонаДоставки = ЗНАЧЕНИЕ(Справочник.бг_ЗоныДоставки.ПустаяСсылка)
	|	И НЕ втДанныеИсточник.КлассГрузоподъемности = ЗНАЧЕНИЕ(Справочник.бг_КлассыГрузоподъемностиТС.ПустаяСсылка)
	|	И НЕ втДанныеИсточник.ТипКузова = ЗНАЧЕНИЕ(Справочник.бг_ТипыКузова.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВнутреннийЗапрос.Период КАК Период,
	|	ВнутреннийЗапрос.ПунктПогрузки КАК ПунктПогрузки,
	|	ВнутреннийЗапрос.Перевозчик КАК Перевозчик,
	|	ВнутреннийЗапрос.ЗонаДоставки КАК ЗонаДоставки,
	|	ВнутреннийЗапрос.КлассГрузоподъемности КАК КлассГрузоподъемности,
	|	ВнутреннийЗапрос.ТипКузова КАК ТипКузова,
	|	ВнутреннийЗапрос.Стоимость КАК Стоимость,
	|	ВнутреннийЗапрос.ДатаОкончания КАК ДатаОкончания,
	|	ВнутреннийЗапрос.ПериодРегистр КАК ПериодРегистр,
	|	ВнутреннийЗапрос.ДатаОкончанияРегистр КАК ДатаОкончанияРегистр,
	|	ВнутреннийЗапрос.ЗагрузкаЗаднимЧислом КАК ЗагрузкаЗаднимЧислом,
	|	ВнутреннийЗапрос.ПересечениеПериодов КАК ПересечениеПериодов
	|ПОМЕСТИТЬ втОшибки
	|ИЗ
	|	(ВЫБРАТЬ
	|		втДанные.Период КАК Период,
	|		втДанные.Перевозчик КАК Перевозчик,
	|		втДанные.ПунктПогрузки КАК ПунктПогрузки,
	|		втДанные.ЗонаДоставки КАК ЗонаДоставки,
	|		втДанные.КлассГрузоподъемности КАК КлассГрузоподъемности,
	|		втДанные.ТипКузова КАК ТипКузова,
	|		втДанные.Стоимость КАК Стоимость,
	|		втДанные.ДатаОкончания КАК ДатаОкончания,
	|		бг_ТарифыТКСрезПоследних.Период КАК ПериодРегистр,
	|		бг_ТарифыТКСрезПоследних.ДатаОкончания КАК ДатаОкончанияРегистр,
	|		бг_ТарифыТКСрезПоследних.Период >= втДанные.ДатаОкончания
	|			И НЕ втДанные.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1) КАК ЗагрузкаЗаднимЧислом,
	|		бг_ТарифыТКСрезПоследних.Период < втДанные.ДатаОкончания
	|			И НЕ втДанные.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			И бг_ТарифыТКСрезПоследних.Период > втДанные.Период КАК ПересечениеПериодов
	|	ИЗ
	|		втДанные КАК втДанные
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_ТарифыТК.СрезПоследних(, ) КАК бг_ТарифыТКСрезПоследних
	|			ПО втДанные.ПунктПогрузки = бг_ТарифыТКСрезПоследних.ПунктПогрузки
	|				И втДанные.Перевозчик = бг_ТарифыТКСрезПоследних.Перевозчик
	|				И втДанные.ЗонаДоставки = бг_ТарифыТКСрезПоследних.ЗонаДоставки
	|				И втДанные.КлассГрузоподъемности = бг_ТарифыТКСрезПоследних.КлассГрузоподъемности
	|				И втДанные.ТипКузова = бг_ТарифыТКСрезПоследних.ТипКузова) КАК ВнутреннийЗапрос
	|ГДЕ
	|	(ВнутреннийЗапрос.ЗагрузкаЗаднимЧислом
	|			ИЛИ ВнутреннийЗапрос.ПересечениеПериодов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОшибки.Период КАК Период,
	|	втОшибки.Перевозчик КАК Перевозчик,
	|	втОшибки.ПунктПогрузки КАК ПунктПогрузки,
	|	втОшибки.ЗонаДоставки КАК ЗонаДоставки,
	|	втОшибки.КлассГрузоподъемности КАК КлассГрузоподъемности,
	|	втОшибки.ТипКузова КАК ТипКузова,
	|	втОшибки.Стоимость КАК Стоимость,
	|	втОшибки.ДатаОкончания КАК ДатаОкончания,
	|	втОшибки.ПериодРегистр КАК ПериодРегистр,
	|	втОшибки.ДатаОкончанияРегистр КАК ДатаОкончанияРегистр,
	|	втОшибки.ЗагрузкаЗаднимЧислом КАК ЗагрузкаЗаднимЧислом,
	|	втОшибки.ПересечениеПериодов КАК ПересечениеПериодов
	|ИЗ
	|	втОшибки КАК втОшибки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанные.Период КАК Период,
	|	втДанные.ПунктПогрузки КАК ПунктПогрузки,
	|	втДанные.Перевозчик КАК Перевозчик,
	|	втДанные.ЗонаДоставки КАК ЗонаДоставки,
	|	втДанные.КлассГрузоподъемности КАК КлассГрузоподъемности,
	|	втДанные.ТипКузова КАК ТипКузова,
	|	втДанные.Стоимость КАК Стоимость,
	|	втДанные.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	втДанные КАК втДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОшибки КАК втОшибки
	|		ПО втДанные.ПунктПогрузки = втОшибки.ПунктПогрузки
	|			И втДанные.ЗонаДоставки = втОшибки.ЗонаДоставки
	|			И втДанные.Перевозчик = втОшибки.Перевозчик
	|			И втДанные.КлассГрузоподъемности = втОшибки.КлассГрузоподъемности
	|			И втДанные.ТипКузова = втОшибки.ТипКузова
	|ГДЕ
	|	втОшибки.Период ЕСТЬ NULL
	|ИТОГИ ПО
	|	Период";
	РезультатЗапросаПакет = Запрос.ВыполнитьПакет();
	ТаблицаОшибок = РезультатЗапросаПакет[РезультатЗапросаПакет.ВГраница() - 1].Выгрузить();
	ВыборкаПериод = РезультатЗапросаПакет[РезультатЗапросаПакет.ВГраница()].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	СтруктураПоиска = Новый Структура("ПунктПогрузки, ЗонаДоставки, КлассГрузоподъемности, ТипКузова, Период, ДатаОкончания"); 
	Пока ВыборкаПериод.Следующий() Цикл
		Выборка = ВыборкаПериод.Выбрать();  
		Пока Выборка.Следующий() Цикл
			ТарифыНаборЗаписей = РегистрыСведений.бг_ТарифыТК.СоздатьНаборЗаписей();
			ТарифыНаборЗаписей.Отбор.Период.Установить(ВыборкаПериод.Период);
			ТарифыНаборЗаписей.Отбор.Перевозчик.Установить(Выборка.Перевозчик);
			ТарифыНаборЗаписей.Отбор.ПунктПогрузки.Установить(Выборка.ПунктПогрузки);
			ТарифыНаборЗаписей.Отбор.ЗонаДоставки.Установить(Выборка.ЗонаДоставки);
			ТарифыНаборЗаписей.Отбор.КлассГрузоподъемности.Установить(Выборка.КлассГрузоподъемности);
			ТарифыНаборЗаписей.Отбор.ТипКузова.Установить(Выборка.ТипКузова);
			
			НоваяЗапись = ТарифыНаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);  
			СтруктураПоиска.Вставить("ПеревозчикКонтрагент", Выборка.Перевозчик);
			ЗагруженныеСтроки = СопоставленныеДанные.НайтиСтроки(СтруктураПоиска);
			Для каждого ЗагруженнаяСтрока Из ЗагруженныеСтроки Цикл
				ЗагруженнаяСтрока.Загружено = Истина;
			КонецЦикла;
			ТарифыНаборЗаписей.Записать(Истина);
		КонецЦикла;
	КонецЦикла;  
	ОтметитьОшибкиЗагрузки(ТаблицаОшибок);
КонецПроцедуры

&НаСервере
Процедура ОтметитьОшибкиЗагрузки(ТаблицаОшибок)
	СтрокиСОшибками = СопоставленныеДанные.НайтиСтроки(Новый Структура("ЕстьНезаполненныеЗначения, Загружено", Ложь, Ложь));
	СтруктураПоиска = Новый Структура("ПунктПогрузки, ЗонаДоставки, КлассГрузоподъемности, ТипКузова, Период, ДатаОкончания"); 
	ТекстЗаднимЧисломШаблон = НСтр("ru='Загрузка задним числом. Текущий тариф установлен %1'");
	ТекстПересечениеПериодовШаблон = НСтр("ru='Пересечение периодов. Текущий тариф установлен %1'");
	Для каждого СтрокаОшибка Из СтрокиСОшибками Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаОшибка);
		СтруктураПоиска.Вставить("ПеревозчикКонтрагент", СтрокаОшибка.Перевозчик);
		НайденныеОшибки = ТаблицаОшибок.НайтиСтроки(СтруктураПоиска);
		Если НайденныеОшибки.Количество() > 0 Тогда
			ТекстОшибкиЗаднимЧислом = ?(Не НайденныеОшибки[0].ЗагрузкаЗаднимЧислом, "", 
				СтрШаблон(ТекстЗаднимЧисломШаблон, НайденныеОшибки[0].ПериодРегистр));
			ТекстОшибкиПересечениеПериодов = ?(Не НайденныеОшибки[0].ПересечениеПериодов, "", 
				СтрШаблон(ТекстПересечениеПериодовШаблон, НайденныеОшибки[0].ПериодРегистр));
			СтрокаОшибка.ЕстьОшибки = Истина;
			СтрокаОшибка.ТекстОшибки = ТекстОшибкиЗаднимЧислом
				+ ?(ТекстОшибкиЗаднимЧислом = "", "", Символы.ПС)
				+ ТекстОшибкиПересечениеПериодов;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УбратьПробелыОпределитьНомерПервойСтрокиСДанными()
	Для СтрокаИндекс = 1 По ЗагруженныеДанные.ВысотаТаблицы Цикл
		ЕстьЗаполненныеЗначения = Ложь;
		Для КолонкаИндекс = 1 По ЗагруженныеДанные.ШиринаТаблицы Цикл
			Значение = СокрЛП(ЗагруженныеДанные.Область(СтрокаИндекс, КолонкаИндекс).Текст);
			ЕстьЗаполненныеЗначения = Не ПустаяСтрока(Значение);
			ЗагруженныеДанные.Область(СтрокаИндекс, КолонкаИндекс).Текст = Значение;
		КонецЦикла;
		Если НомерПервойСтрокиСДанными = 0 И ЕстьЗаполненныеЗначения Тогда
			НомерПервойСтрокиСДанными = СтрокаИндекс;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗагруженныеДанныеНаСервере(АдресРезультата)
	НомерПервойСтрокиСДанными = 0;
	ЗагруженныеДанные.Очистить();
	СопоставленныеДанные.Очистить();

	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xlsx");
	
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресРезультата);
	ДанныеФайла.Записать(ИмяВременногоФайла);
	ЗагруженныеДанные.Прочитать(ИмяВременногоФайла, СпособЧтенияЗначенийТабличногоДокумента.Текст);
	УдалитьФайлы(ИмяВременногоФайла);
	
	УбратьПробелыОпределитьНомерПервойСтрокиСДанными();
	АнализИменКолонок();
КонецПроцедуры          

&НаСервере
Процедура АнализИменКолонок()
	ИменаКолонок = Новый Массив;
	Для КолонкаИндекс = 1 По ЗагруженныеДанные.ШиринаТаблицы Цикл
		ИменаКолонок.Добавить(ЗагруженныеДанные.Область(НомерПервойСтрокиСДанными, КолонкаИндекс).Текст);
	КонецЦикла;

	НастройкиКолонок.Очистить();          
	Для Индекс = 0 По ИменаКолонок.ВГраница() Цикл
		ИменаКолонок[Индекс] = НРег(ИменаКолонок[Индекс]);
	КонецЦикла;

	ДобавитьСтрокуРеквизита("Период", "Дата начала", ИменаКолонок);
	ДобавитьСтрокуРеквизита("ДатаОкончания", "Дата окончания", ИменаКолонок);
	ДобавитьСтрокуРеквизита("Перевозчик", "Перевозчик", ИменаКолонок);
	ДобавитьСтрокуРеквизита("ПунктПогрузки", "Пункт погрузки", ИменаКолонок);
	ДобавитьСтрокуРеквизита("ЗонаДоставки", "Зона доставки", ИменаКолонок);
	ДобавитьСтрокуРеквизита("КлассГрузоподъемности", "Тоннаж АМ", ИменаКолонок);
	ДобавитьСтрокуРеквизита("ТипКузова", "Тип кузова", ИменаКолонок);
	ДобавитьСтрокуРеквизита("Стоимость", "Стоимость", ИменаКолонок);

	НомерПервойСтрокиСДанными = НомерПервойСтрокиСДанными + 1;

КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуРеквизита(ИмяРеквизита, ТекстПоиска, ИменаКолонок)
	НомерКолонки = ИменаКолонок.Найти(НРег(ТекстПоиска));
	Если НомерКолонки = Неопределено Тогда
		НомерКолонки = 0;
	Иначе
		НомерКолонки = НомерКолонки + 1;
	КонецЕсли;
	НоваяСтрока = НастройкиКолонок.Добавить();
	НоваяСтрока.ИмяРеквизита = ИмяРеквизита;
	НоваяСтрока.НомерКолонки = НомерКолонки;
КонецПроцедуры

#Область СопоставлениеДанных

&НаКлиенте
Функция ЕстьВсеДанныеДляСопоставления()
	Отказ = Ложь; 
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ТекстОшибки = НСтр("ru='Укажите организацию'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "Организация", , Отказ);
	КонецЕсли;
	Для каждого СтрокаНастройки Из НастройкиКолонок Цикл
		Если СтрокаНастройки.НомерКолонки = 0 Тогда
			ТекстОшибки = НСтр("ru='Для реквизита %1 укажите номер колонки источника, или укажите ""-1"", чтобы игнорировать'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, СтрокаНастройки.ИмяРеквизита);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "НастройкиКолонокНомерКолонки", , Отказ);
		КонецЕсли;
	КонецЦикла;	
	Возврат Не Отказ;
КонецФункции

&НаСервере
Процедура СопоставитьДанныеСервер()                     
	НомераКолонок = Новый Соответствие;
	ТипЗначенияСтоимость = ОбщегоНазначения.ОписаниеТипаЧисло(15, 2);
	Для каждого СтрокаНастройки Из НастройкиКолонок Цикл
		НомераКолонок.Вставить(СтрокаНастройки.ИмяРеквизита, СтрокаНастройки.НомерКолонки);
	КонецЦикла;       
	КэшПП = Неопределено; КэшЗД = Неопределено;	КэшКГ = Неопределено; КэшТК = Неопределено; КэшП = Неопределено;
	СопоставленныеДанные.Очистить();                 
	НомерСтроки = 0;
	Для ИндексСтроки = НомерПервойСтрокиСДанными По ЗагруженныеДанные.ВысотаТаблицы Цикл
		НоваяСтрока = СопоставленныеДанные.Добавить();
		НомерСтроки = НомерСтроки + 1;
		НоваяСтрока.НомерСтроки = НомерСтроки;
		ОпределитьДату(НоваяСтрока.Период, ИндексСтроки, НомераКолонок["Период"], ТекущаяДатаСеанса());
		ОпределитьДату(НоваяСтрока.ДатаОкончания, ИндексСтроки, НомераКолонок["ДатаОкончания"], Дата(1, 1, 1));
		ОпределитьПеревозчика(НоваяСтрока.ПеревозчикСтрока, НоваяСтрока.Перевозчик, НоваяСтрока.ПеревозчикКонтрагент, 
			ИндексСтроки, НомераКолонок["Перевозчик"], КэшП);
		ОпределитьПунктПогрузки(НоваяСтрока.ПунктПогрузкиСтрока, НоваяСтрока.ПунктПогрузки, 
			ИндексСтроки, НомераКолонок["ПунктПогрузки"], КэшПП);
		ОпределитьЗонуДоставки(НоваяСтрока.ЗонаДоставкиСтрока, НоваяСтрока.ЗонаДоставки, 
			ИндексСтроки, НомераКолонок["ЗонаДоставки"], КэшЗД);
		ОпределитьКлассГрузоподъемности(НоваяСтрока.КлассГрузоподъемностиСтрока, НоваяСтрока.КлассГрузоподъемности, 
		 	ИндексСтроки, НомераКолонок["КлассГрузоподъемности"], КэшКГ);
		ОпределитьТипКузова(НоваяСтрока.ТипКузоваСтрока, НоваяСтрока.ТипКузова, 
			ИндексСтроки, НомераКолонок["ТипКузова"], КэшТК);
		ОпределитьСтоимость(НоваяСтрока.Стоимость, ИндексСтроки, НомераКолонок["Стоимость"]);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОпределитьДату(Результат, НомерСтроки, НомерКолонки, ЗначениеПоУмолчанию = Неопределено)
	Результат = ЗначениеПоУмолчанию;
	Если НомерКолонки > 0 И НомерКолонки <= ЗагруженныеДанные.ШиринаТаблицы Тогда
		Значение = ЗагруженныеДанные.Область(НомерСтроки, НомерКолонки).Текст;
		Результат = СтроковыеФункцииКлиентСервер.СтрокаВДату(Значение);
	КонецЕсли;   
КонецПроцедуры

&НаСервере
Процедура ОпределитьСтоимость(Результат, НомерСтроки, НомерКолонки)
	Результат = 0;
	Если НомерКолонки > 0 И НомерКолонки <= ЗагруженныеДанные.ШиринаТаблицы Тогда
		ТипЗначенияЧисло = ОбщегоНазначения.ОписаниеТипаЧисло(15, 2);
		Результат = ТипЗначенияЧисло.ПривестиЗначение(ЗагруженныеДанные.Область(НомерСтроки, НомерКолонки).Текст);
	КонецЕсли;   
КонецПроцедуры

&НаСервере
Процедура ОпределитьПеревозчика(ЗначениеТекст, Партнер, Контрагент, НомерСтроки, НомерКолонки, Кэш)
	Результат = Неопределено;
	Если НомерКолонки > 0 И НомерКолонки <= ЗагруженныеДанные.ШиринаТаблицы Тогда
		ЗначениеТекст = ЗагруженныеДанные.Область(НомерСтроки, НомерКолонки).Текст;
		Если Кэш = Неопределено Тогда
			Кэш = Новый Соответствие;
		КонецЕсли;     
		Результат = Кэш[ЗначениеТекст];
		Если Результат = Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	Контрагенты.Ссылка КАК Контрагент,
			|	Партнеры.Ссылка КАК Партнер
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Партнеры КАК Партнеры
			|		ПО Контрагенты.Партнер = Партнеры.Ссылка
			|			И (Партнеры.Наименование = &Наименование)
			|			И (Партнеры.Перевозчик)";
			Запрос.УстановитьПараметр("Наименование", ЗначениеТекст);
			Выборка = Запрос.Выполнить().Выбрать();
			Результат = Новый Структура("Партнер, Контрагент", 
				Справочники.Партнеры.ПустаяСсылка(), Справочники.Контрагенты.ПустаяСсылка());
			Если Выборка.Следующий() Тогда
				ЗаполнитьЗначенияСвойств(Результат, Выборка);
			КонецЕсли;
			Кэш.Вставить(ЗначениеТекст, Результат);
		КонецЕсли;                                                         
	КонецЕсли;   
	Партнер = Результат.Партнер;
	Контрагент = Результат.Контрагент;
КонецПроцедуры

&НаСервере
Процедура ОпределитьПунктПогрузки(Значение, ЗначениеСсылка, НомерСтроки, НомерКолонки, Кэш)
	Результат = Неопределено;
	Если НомерКолонки > 0 И НомерКолонки <= ЗагруженныеДанные.ШиринаТаблицы Тогда
		Значение = ЗагруженныеДанные.Область(НомерСтроки, НомерКолонки).Текст;
		Если Кэш = Неопределено Тогда
			Кэш = Новый Соответствие;
		КонецЕсли;     
		Результат = Кэш[Значение];
		Если Результат = Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	битПунктыНазначения.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.битПунктыНазначения КАК битПунктыНазначения
			|ГДЕ
			|	битПунктыНазначения.Клиент = &Клиент
			|	И (битПунктыНазначения.НаименованиеЛогист = &Наименование
			|	ИЛИ битПунктыНазначения.НаименованиеПолное = &Наименование
			|	ИЛИ битПунктыНазначения.Наименование = &Наименование)";
			Запрос.УстановитьПараметр("Клиент", Организация);
			Запрос.УстановитьПараметр("Наименование", Значение);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Результат = Выборка.Ссылка;
			Иначе
				Результат = Справочники.битПунктыНазначения.ПустаяСсылка();
			КонецЕсли;
			Кэш.Вставить(Значение, Результат);
		КонецЕсли;                                                         
	КонецЕсли;   
	ЗначениеСсылка = Результат;
КонецПроцедуры

&НаСервере
Процедура ОпределитьЗонуДоставки(Значение, ЗначениеСсылка, НомерСтроки, НомерКолонки, Кэш)
	Результат = Неопределено;
	Если НомерКолонки > 0 И НомерКолонки <= ЗагруженныеДанные.ШиринаТаблицы Тогда
		Значение = ЗагруженныеДанные.Область(НомерСтроки, НомерКолонки).Текст;
		Если Кэш = Неопределено Тогда
			Кэш = Новый Соответствие;
		КонецЕсли;     
		Результат = Кэш[Значение];
		Если Результат = Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	бг_ЗоныДоставки.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.бг_ЗоныДоставки КАК бг_ЗоныДоставки
			|ГДЕ
			|	бг_ЗоныДоставки.Наименование = &Наименование";
			Запрос.УстановитьПараметр("Наименование", Значение);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Результат = Выборка.Ссылка;
			Иначе
				Результат = Справочники.бг_ЗоныДоставки.ПустаяСсылка();
			КонецЕсли;
			Кэш.Вставить(Значение, Результат);
		КонецЕсли;                                                         
	КонецЕсли;   
	ЗначениеСсылка = Результат;
КонецПроцедуры

&НаСервере
Процедура ОпределитьКлассГрузоподъемности(Значение, ЗначениеСсылка, НомерСтроки, НомерКолонки, Кэш)
	Результат = Неопределено;
	Если НомерКолонки > 0 И НомерКолонки <= ЗагруженныеДанные.ШиринаТаблицы Тогда
		Значение = ЗагруженныеДанные.Область(НомерСтроки, НомерКолонки).Текст;
		Если Кэш = Неопределено Тогда
			Кэш = Новый Соответствие;
		КонецЕсли;     
		Результат = Кэш[Значение];
		Если Результат = Неопределено Тогда
			Результат = Справочники.бг_КлассыГрузоподъемностиТС.НайтиПоНаименованию(Значение);
			Кэш.Вставить(Значение, Результат);
		КонецЕсли;                                                         
	КонецЕсли;   
	ЗначениеСсылка = Результат;
КонецПроцедуры

&НаСервере
Процедура ОпределитьТипКузова(Значение, ЗначениеСсылка, НомерСтроки, НомерКолонки, Кэш)
	Результат = Неопределено;
	Если НомерКолонки > 0 И НомерКолонки <= ЗагруженныеДанные.ШиринаТаблицы Тогда
		Значение = ЗагруженныеДанные.Область(НомерСтроки, НомерКолонки).Текст;
		Если Кэш = Неопределено Тогда
			Кэш = Новый Соответствие;
		КонецЕсли;     
		Результат = Кэш[Значение];
		Если Результат = Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	бг_ТипыКузова.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.бг_ТипыКузова КАК бг_ТипыКузова
			|ГДЕ
			|	бг_ТипыКузова.Наименование = &Наименование";
			Запрос.УстановитьПараметр("Наименование", ВРег(Значение));
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Результат = Выборка.Ссылка;
			Иначе
				Результат = Справочники.бг_ТипыКузова.ПустаяСсылка();
			КонецЕсли;
			Кэш.Вставить(Значение, Результат);
		КонецЕсли;                                                         
	КонецЕсли;   
	ЗначениеСсылка = Результат;
КонецПроцедуры

#КонецОбласти

#КонецОбласти